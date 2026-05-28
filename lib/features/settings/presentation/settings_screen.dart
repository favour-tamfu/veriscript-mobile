import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../referral/data/referral_repository.dart';

final _referralCodeProvider = FutureProvider<String>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return '';
  return ref.read(referralRepositoryProvider).getReferralCode(userId);
});

final _referralCountProvider = FutureProvider<int>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return 0;
  return ref.read(referralRepositoryProvider).getReferralCount(userId);
});

final _bonusScansProvider = FutureProvider<int>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return 0;
  return ref.read(referralRepositoryProvider).getBonusScans(userId);
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    final isFrench = locale.languageCode == 'fr';
    final referralCodeAsync = ref.watch(_referralCodeProvider);
    final referralCountAsync = ref.watch(_referralCountProvider);
    final bonusScansAsync = ref.watch(_bonusScansProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          // Language toggle
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(l10n.settingsLanguage),
            trailing: SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'en', label: Text('EN')),
                ButtonSegment<String>(value: 'fr', label: Text('FR')),
              ],
              selected: <String>{locale.languageCode},
              onSelectionChanged: (selection) {
                ref
                    .read(localeProvider.notifier)
                    .setLocale(Locale(selection.first));
              },
            ),
          ),
          const Divider(height: 1),

          // Google Drive
          ListTile(
            leading: const Icon(Icons.drive_eta_rounded, color: AppColors.vsAccent),
            title: Text(isFrench ? 'Google Drive' : 'Google Drive'),
            subtitle: Text(
              isFrench
                  ? 'Importer et exporter des documents'
                  : 'Import & export documents',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.cloudDrive),
          ),
          const Divider(height: 1),

          // Referral section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              isFrench ? 'Parrainer un ami' : 'Refer a Friend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.vsPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          // Referral card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFrench
                          ? 'Partagez votre code et obtenez tous les deux 2 scans bonus!'
                          : 'Share your code and both of you get 2 bonus scans!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),

                    // Referral code display
                    referralCodeAsync.when(
                      data: (code) => _ReferralCodeRow(
                        code: code.isEmpty
                            ? (isFrench ? 'Chargement...' : 'Loading...')
                            : code,
                        isFrench: isFrench,
                      ),
                      loading: () => const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (_, __) => Text(
                        isFrench ? 'Impossible de charger le code' : 'Failed to load code',
                        style: TextStyle(color: AppColors.vsError),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Friend count + bonus scans
                    Row(
                      children: [
                        referralCountAsync.when(
                          data: (count) => Chip(
                            avatar: const Icon(Icons.people_rounded, size: 16),
                            label: Text(
                              isFrench
                                  ? '$count ami${count == 1 ? '' : 's'} inscrit${count == 1 ? '' : 's'}'
                                  : '$count friend${count == 1 ? '' : 's'} joined',
                            ),
                          ),
                          loading: () => const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                        const SizedBox(width: 8),
                        bonusScansAsync.when(
                          data: (bonus) => bonus > 0
                              ? Chip(
                                  avatar: const Icon(
                                    Icons.stars_rounded,
                                    size: 16,
                                    color: AppColors.vsWarning,
                                  ),
                                  label: Text(
                                    isFrench
                                        ? '+$bonus scans bonus'
                                        : '+$bonus bonus scans',
                                  ),
                                )
                              : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // WhatsApp share button
                    SizedBox(
                      width: double.infinity,
                      child: referralCodeAsync.when(
                        data: (code) => ElevatedButton.icon(
                          onPressed: code.isEmpty
                              ? null
                              : () {
                                  final shareText = isFrench
                                      ? 'Utilisez mon code $code pour vous inscrire sur VeriScript et obtenez 2 scans bonus! https://play.google.com/store/apps/details?id=com.veriscipt.mobile'
                                      : 'Use my code $code to sign up for VeriScript and get 2 bonus scans! https://play.google.com/store/apps/details?id=com.veriscipt.mobile';
                                  final uri = Uri.parse(
                                    'https://wa.me/681848500?text=${Uri.encodeComponent(shareText)}',
                                  );
                                  launchUrl(uri, mode: LaunchMode.externalApplication);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.share_rounded),
                          label: Text(
                            isFrench
                                ? 'Partager sur WhatsApp'
                                : 'Share on WhatsApp',
                          ),
                        ),
                        loading: () => ElevatedButton(
                          onPressed: null,
                          child: Text(
                            isFrench ? 'Partager sur WhatsApp' : 'Share on WhatsApp',
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ReferralCodeRow extends StatelessWidget {
  const _ReferralCodeRow({required this.code, required this.isFrench});

  final String code;
  final bool isFrench;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.vsLightGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.vsPrimary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFrench ? 'Votre code de parrainage' : 'Your referral code',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.vsGray,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.vsPrimary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFrench ? 'Code copié!' : 'Code copied!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded),
            tooltip: isFrench ? 'Copier le code' : 'Copy code',
          ),
        ],
      ),
    );
  }
}
