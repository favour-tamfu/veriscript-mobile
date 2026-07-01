import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/friendly_error.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../domain/language.dart';
import 'translator_notifier.dart';

class TranslatorScreen extends ConsumerStatefulWidget {
  const TranslatorScreen({super.key, this.initialText});

  final String? initialText;

  @override
  ConsumerState<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends ConsumerState<TranslatorScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: widget.initialText ?? '');
    if (widget.initialText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(translatorNotifierProvider.notifier).initWithText(widget.initialText!);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final state = ref.watch(translatorNotifierProvider);
    final notifier = ref.read(translatorNotifierProvider.notifier);

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Traducteur' : 'Translator'),
      body: Column(
        children: [
          // Language selector bar
          _buildLanguageBar(context, state, notifier, isFrench),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Document translation entry
                  _buildDocumentBanner(context, isFrench),
                  const SizedBox(height: 12),
                  // Input area
                  _buildInputArea(context, state, notifier, isFrench),
                  const SizedBox(height: 12),
                  // Quota bar
                  _buildQuotaBar(context, state, isFrench),
                  const SizedBox(height: 12),
                  // Output area
                  _buildOutputArea(context, state, notifier, isFrench),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBar(BuildContext context, TranslatorState state, TranslatorNotifier notifier, bool isFrench) {
    return Container(
      color: AppColors.vsPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _LanguageButton(
              code: state.sourceLang,
              isFrench: isFrench,
              isSource: true,
              onTap: () => _showLanguagePicker(context, isSource: true, notifier: notifier, isFrench: isFrench),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            onPressed: notifier.swapLanguages,
          ),
          Expanded(
            child: _LanguageButton(
              code: state.targetLang,
              isFrench: isFrench,
              isSource: false,
              onTap: () => _showLanguagePicker(context, isSource: false, notifier: notifier, isFrench: isFrench),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentBanner(BuildContext context, bool isFrench) {
    return InkWell(
      onTap: () => context.push(AppRoutes.translatorDocument),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.vsAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.vsAccent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.description, color: AppColors.vsAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFrench ? 'Traduire un document' : 'Translate a document',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    isFrench
                        ? 'PDF ou Word — la mise en page est conservée'
                        : 'PDF or Word — keeps the original layout',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.vsGray),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.vsAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, TranslatorState state, TranslatorNotifier notifier, bool isFrench) {
    final charCount = state.inputText.length;
    final isNearLimit = charCount > 4000;
    final isAtLimit = charCount >= 5000;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.vsSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          if (state.fromOcr)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.vsAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.camera_alt, color: AppColors.vsAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    isFrench ? 'Depuis le numériseur OCR' : 'From OCR Scanner',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsAccent),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _inputController,
            maxLines: 6,
            maxLength: 5000,
            onChanged: notifier.setInputText,
            decoration: InputDecoration(
              hintText: isFrench ? 'Entrez le texte à traduire...' : 'Enter text to translate...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Text(
                  '$charCount / 5000',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isAtLimit ? AppColors.vsError : isNearLimit ? AppColors.vsWarning : AppColors.vsGray,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _inputController.clear();
                    notifier.clearInput();
                  },
                  color: AppColors.vsGray,
                ),
                ElevatedButton(
                  onPressed: notifier.translate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text(isFrench ? 'Traduire' : 'Translate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaBar(BuildContext context, TranslatorState state, bool isFrench) {
    final used = state.charsUsedThisMonth;
    final max = state.charsLimit;
    final pct = used / max;
    final color = pct < 0.8 ? AppColors.vsAccent : pct < 1.0 ? AppColors.vsWarning : AppColors.vsError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isFrench
              ? '$used / $max caractères utilisés ce mois'
              : '$used / $max chars used this month',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
        ),
        const SizedBox(height: 4),
        LinearPercentIndicator(
          lineHeight: 4,
          percent: pct.clamp(0.0, 1.0),
          backgroundColor: AppColors.vsLightGray,
          progressColor: color,
          padding: EdgeInsets.zero,
          barRadius: const Radius.circular(2),
        ),
      ],
    );
  }

  Widget _buildOutputArea(BuildContext context, TranslatorState state, TranslatorNotifier notifier, bool isFrench) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: AppColors.vsBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: _buildOutputContent(context, state, notifier, isFrench),
    );
  }

  Widget _buildOutputContent(BuildContext context, TranslatorState state, TranslatorNotifier notifier, bool isFrench) {
    switch (state.translatorStatus) {
      case 'idle':
        return Text(
          isFrench ? 'La traduction apparaîtra ici' : 'Translation will appear here',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.vsGray,
            fontStyle: FontStyle.italic,
          ),
        );

      case 'translating':
        return Shimmer.fromColors(
          baseColor: AppColors.vsLightGray,
          highlightColor: AppColors.vsSurface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(3, (_) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
        );

      case 'done':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.fromCache)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.vsSuccess.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFrench ? '⚡ Instantané — depuis le cache' : '⚡ Instant — from cache',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsSuccess),
                ),
              ),
            if (state.detectedSourceLang != null && state.sourceLang == 'auto')
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.vsAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${isFrench ? "Détecté" : "Detected"}: ${state.detectedSourceLang}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsAccent),
                ),
              ),
            SelectableText(
              state.translatedText ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  color: AppColors.vsGray,
                  onPressed: () async {
                    await notifier.copyTranslation();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isFrench ? 'Copié!' : 'Copied!')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 20),
                  color: AppColors.vsGray,
                  onPressed: notifier.swapLanguages,
                ),
              ],
            ),
          ],
        );

      case 'failed':
        return Text(
          friendlyError(state.errorMessage, isFrench: isFrench),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.vsError),
        );

      case 'quota_exceeded':
        return Text(
          isFrench
              ? 'Limite de traduction atteinte pour ce mois'
              : 'Translation limit reached for this month',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.vsError),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _showLanguagePicker(
    BuildContext context, {
    required bool isSource,
    required TranslatorNotifier notifier,
    required bool isFrench,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.vsSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _LanguagePickerSheet(
        isSource: isSource,
        isFrench: isFrench,
        onSelect: (code) {
          Navigator.pop(context);
          if (isSource) {
            notifier.setSourceLang(code);
          } else {
            notifier.setTargetLang(code);
          }
        },
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.code,
    required this.isFrench,
    required this.isSource,
    required this.onTap,
  });

  final String code;
  final bool isFrench;
  final bool isSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = code == 'auto'
        ? (isFrench ? 'Détection auto' : 'Auto-detect')
        : _languageName(code, isFrench);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

class _LanguagePickerSheet extends StatefulWidget {
  const _LanguagePickerSheet({
    required this.isSource,
    required this.isFrench,
    required this.onSelect,
  });

  final bool isSource;
  final bool isFrench;
  final void Function(String code) onSelect;

  @override
  State<_LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<_LanguagePickerSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final all = kAllLanguages;
    final filtered = _search.isEmpty
        ? all
        : all.where((l) {
            final query = _search.toLowerCase();
            return l.nameEn.toLowerCase().contains(query) ||
                l.nameFr.toLowerCase().contains(query) ||
                l.code.toLowerCase().contains(query);
          }).toList();

    final priority = filtered.where((l) => kPriorityLanguages.any((p) => p.code == l.code)).toList();
    final others = filtered.where((l) => !kPriorityLanguages.any((p) => p.code == l.code)).toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.vsLightGray, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.isFrench ? 'Rechercher une langue...' : 'Search languages...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.vsBackground,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (widget.isSource) ...[
                    ListTile(
                      title: Text(widget.isFrench ? 'Détection auto' : 'Auto-detect'),
                      onTap: () => widget.onSelect('auto'),
                    ),
                    const Divider(),
                  ],
                  if (priority.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        widget.isFrench ? 'Recommandé' : 'Recommended',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.vsGray,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...priority.map((l) => ListTile(
                      title: Text(widget.isFrench ? l.nameFr : l.nameEn),
                      subtitle: Text(l.code.toUpperCase()),
                      onTap: () => widget.onSelect(l.code),
                    )),
                    const Divider(),
                  ],
                  ...others.map((l) => ListTile(
                    title: Text(widget.isFrench ? l.nameFr : l.nameEn),
                    subtitle: Text(l.code.toUpperCase()),
                    onTap: () => widget.onSelect(l.code),
                  )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

String _languageName(String code, bool isFrench) {
  final lang = kAllLanguages.firstWhere(
    (l) => l.code == code,
    orElse: () => Language(code: code, nameEn: code.toUpperCase(), nameFr: code.toUpperCase()),
  );
  return isFrench ? lang.nameFr : lang.nameEn;
}
