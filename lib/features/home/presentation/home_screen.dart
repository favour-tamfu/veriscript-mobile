import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/local_db/app_database.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_empty_state.dart';
import '../../../core/widgets/vs_offline_banner.dart';
import '../../notifications/presentation/notifications_providers.dart';
import '../data/quota_repository.dart';
import 'quota_bar_widget.dart';
import 'tool_card_widget.dart';

final recentDocumentsProvider = FutureProvider<List<DocumentsTableData>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    return const <DocumentsTableData>[];
  }

  return ref.watch(documentsDaoProvider).getRecentDocuments(userId);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final user = Supabase.instance.client.auth.currentUser;
    final displayName = _displayNameFor(user);
    final greeting = _timeGreeting(isFrench, DateTime.now());
    final quotaAsync = ref.watch(quotaProvider);
    final isOffline = ref.watch(isOfflineProvider);
    final documentsAsync = ref.watch(recentDocumentsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.vsPrimary,
            foregroundColor: Colors.white,
            pinned: true,
            expandedHeight: 220,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            title: const Text('VeriScript'),
            actions: [
              IconButton(
                onPressed: () => context.push(AppRoutes.notifications),
                icon: Badge(
                  isLabelVisible: ref.watch(unreadNotificationsCountProvider) > 0,
                  label: Text('${ref.watch(unreadNotificationsCountProvider)}'),
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(24, 96, 24, 24),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting, $displayName',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isFrench
                            ? 'Que souhaitez-vous faire aujourd\'hui?'
                            : 'What would you like to do today?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.vsAccent,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOffline) const VsOfflineBanner(),
                  QuotaBarWidget(
                    quotaAsync: quotaAsync,
                    isFrench: isFrench,
                    onUpgrade: () => context.push(AppRoutes.settings),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.80,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      ToolCardWidget(
                        icon: Icons.document_scanner_rounded,
                        title: isFrench
                            ? 'Vérif. de plagiat'
                            : 'Plagiarism Check',
                        description: isFrench
                            ? 'Analysez le contenu copié'
                            : 'Scan for copied content',
                        onTap: () => context.push(AppRoutes.scanner),
                      ),
                      ToolCardWidget(
                        icon: Icons.swap_horiz_rounded,
                        title: isFrench ? 'Convertisseur' : 'File Converter',
                        description: 'PDF, DOCX, TXT',
                        onTap: () => context.push(AppRoutes.converter),
                      ),
                      ToolCardWidget(
                        icon: Icons.camera_alt_rounded,
                        title: isFrench ? 'Numériseur OCR' : 'OCR Scanner',
                        description: isFrench
                            ? 'Numérisez des docs physiques'
                            : 'Scan physical docs',
                        onTap: () => context.push(AppRoutes.ocr),
                      ),
                      ToolCardWidget(
                        icon: Icons.translate_rounded,
                        title: isFrench ? 'Traducteur' : 'Translator',
                        description: isFrench ? '100+ langues' : '100+ languages',
                        onTap: () => context.push(AppRoutes.translator),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isFrench ? 'Documents récents' : 'Recent Documents',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.history),
                        child: Text(isFrench ? 'Voir tout' : 'See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  documentsAsync.when(
                    data: (documents) {
                      if (documents.isEmpty) {
                        return VsEmptyState(
                          lottieAsset: 'assets/animations/empty.json',
                          title: isFrench ? 'Aucun document' : 'No documents yet',
                          subtitle: isFrench
                              ? 'Importez votre premier document!'
                              : 'Upload your first document!',
                        );
                      }

                      return SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final document = documents[index];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 12),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        _iconForType(document.type),
                                        color: AppColors.vsAccent,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        document.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat.yMMMd().format(document.createdAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: AppColors.vsGray),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.vsAccent.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          document.type.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: AppColors.vsAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (_, __) => const SizedBox.shrink(),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: AppColors.vsAccent, width: 4),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isFrench
                              ? 'Partagez VeriScript avec votre classe'
                              : 'Share VeriScript with your class',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            final message = isFrench
                                ? 'Découvrez VeriScript — détection de plagiat + conversion de fichiers pour les étudiants au Cameroun! Télécharger: https://play.google.com/store/apps/details?id=com.veriscipt.mobile'
                                : 'Check out VeriScript — plagiarism detection + file conversion for students in Cameroon! Download: https://play.google.com/store/apps/details?id=com.veriscipt.mobile';
                            final uri = Uri.parse(
                              'https://wa.me/681848500?text=${Uri.encodeComponent(message)}',
                            );
                            openExternalUrl(context, uri, isFrench: isFrench);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.share),
                          label: Text(
                            isFrench
                                ? 'Partager sur WhatsApp'
                                : 'Share on WhatsApp',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _displayNameFor(User? user) {
  final metadataName = user?.userMetadata?['display_name']?.toString();
  if (metadataName != null && metadataName.trim().isNotEmpty) {
    return metadataName.split(' ').first;
  }

  final email = user?.email ?? 'Friend';
  return email.split('@').first;
}

String _timeGreeting(bool isFrench, DateTime now) {
  if (now.hour < 12) {
    return isFrench ? 'Bonjour' : 'Good morning';
  }
  if (now.hour < 18) {
    return isFrench ? 'Bon après-midi' : 'Good afternoon';
  }
  return isFrench ? 'Bonsoir' : 'Good evening';
}

IconData _iconForType(String type) {
  switch (type.toLowerCase()) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'docx':
      return Icons.description;
    default:
      return Icons.article;
  }
}
