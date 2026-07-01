import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/file_download.dart';
import '../../../core/utils/friendly_error.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../cloud/presentation/drive_file_picker.dart';
import '../domain/language.dart';
import 'document_translator_notifier.dart';

/// Layout-preserving document translation: pick a PDF/Word/text file, choose
/// languages, and download the translated document back.
class DocumentTranslatorScreen extends ConsumerWidget {
  const DocumentTranslatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final state = ref.watch(documentTranslatorNotifierProvider);
    final notifier = ref.read(documentTranslatorNotifierProvider.notifier);

    return Scaffold(
      appBar: VsAppBar(
        title: isFrench ? 'Traduire un document' : 'Translate a Document',
      ),
      body: Column(
        children: [
          _LanguageBar(state: state, notifier: notifier, isFrench: isFrench),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildBody(context, state, notifier, isFrench),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DocumentTranslatorState state,
    DocumentTranslatorNotifier notifier,
    bool isFrench,
  ) {
    switch (state.status) {
      case 'uploading':
      case 'translating':
      case 'importing':
        return _ProgressView(status: state.status, isFrench: isFrench);
      case 'done':
        return _DoneView(state: state, notifier: notifier, isFrench: isFrench);
    }

    if (state.selectedFile == null) {
      return _PickView(
        notifier: notifier,
        isFrench: isFrench,
        errorMessage: state.status == 'failed' ? state.errorMessage : null,
      );
    }

    return _OptionsView(state: state, notifier: notifier, isFrench: isFrench);
  }
}

class _LanguageBar extends StatelessWidget {
  const _LanguageBar({
    required this.state,
    required this.notifier,
    required this.isFrench,
  });

  final DocumentTranslatorState state;
  final DocumentTranslatorNotifier notifier;
  final bool isFrench;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.vsPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _LangButton(
              label: state.sourceLang == 'auto'
                  ? (isFrench ? 'Détection auto' : 'Auto-detect')
                  : _languageName(state.sourceLang, isFrench),
              onTap: () => _pickLanguage(context, isSource: true),
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          Expanded(
            child: _LangButton(
              label: _languageName(state.targetLang, isFrench),
              onTap: () => _pickLanguage(context, isSource: false),
            ),
          ),
        ],
      ),
    );
  }

  void _pickLanguage(BuildContext context, {required bool isSource}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.vsSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _LanguageSheet(
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

class _LangButton extends StatelessWidget {
  const _LangButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
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

class _PickView extends StatelessWidget {
  const _PickView({
    required this.notifier,
    required this.isFrench,
    this.errorMessage,
  });

  final DocumentTranslatorNotifier notifier;
  final bool isFrench;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: notifier.pickDocument,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              decoration: BoxDecoration(
                color: AppColors.vsSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.vsLightGray),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate_rounded,
                      size: 64, color: AppColors.vsAccent),
                  const SizedBox(height: 16),
                  Text(
                    isFrench
                        ? 'Appuyez pour choisir un document'
                        : 'Tap to choose a document',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isFrench
                        ? 'PDF, Word, PowerPoint, Excel ou texte · Max 10 Mo'
                        : 'PDF, Word, PowerPoint, Excel or text · Max 10MB',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.vsGray),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final driveFile = await showDriveFilePicker(context);
                if (driveFile == null) return;
                messenger.showSnackBar(SnackBar(
                  content: Text(isFrench
                      ? 'Importation de ${driveFile.name}...'
                      : 'Importing ${driveFile.name}...'),
                ));
                await notifier.importFromDrive(driveFile);
              },
              icon: const Icon(Icons.cloud_download),
              label: Text(
                isFrench
                    ? 'Importer depuis Google Drive'
                    : 'Import from Google Drive',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isFrench
                ? 'La mise en page, les images et les tableaux sont conservés.'
                : 'Layout, images and tables are preserved.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.vsGray),
            textAlign: TextAlign.center,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              friendlyError(errorMessage, isFrench: isFrench),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.vsError),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionsView extends StatelessWidget {
  const _OptionsView({
    required this.state,
    required this.notifier,
    required this.isFrench,
  });

  final DocumentTranslatorState state;
  final DocumentTranslatorNotifier notifier;
  final bool isFrench;

  @override
  Widget build(BuildContext context) {
    final file = state.selectedFile!;
    final ext = (state.fileName ?? '').split('.').last.toUpperCase();

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: AppColors.vsAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.fileName ?? file.path,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatSize(state.fileSizeBytes ?? 0),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.vsGray),
                      ),
                    ],
                  ),
                ),
                Chip(label: Text(ext)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isFrench
              ? 'Choisissez les langues dans la barre du haut, puis traduisez.'
              : 'Pick the languages in the top bar, then translate.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.vsGray),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: notifier.translate,
            icon: const Icon(Icons.translate),
            label: Text(isFrench ? 'Traduire le document' : 'Translate Document'),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: notifier.reset,
            child: Text(
              isFrench ? 'Choisir un autre fichier' : 'Choose different file',
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.status, required this.isFrench});

  final String status;
  final bool isFrench;

  @override
  Widget build(BuildContext context) {
    final String label;
    if (status == 'importing') {
      label = isFrench
          ? 'Importation depuis Google Drive...'
          : 'Importing from Google Drive...';
    } else if (status == 'uploading') {
      label =
          isFrench ? 'Envoi de votre document...' : 'Uploading your document...';
    } else {
      label = isFrench
          ? 'Traduction en cours — la mise en page est conservée...'
          : 'Translating — keeping the original layout...';
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(color: AppColors.vsAccent),
          ),
          const SizedBox(height: 24),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({
    required this.state,
    required this.notifier,
    required this.isFrench,
  });

  final DocumentTranslatorState state;
  final DocumentTranslatorNotifier notifier;
  final bool isFrench;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.vsSuccess, size: 80),
          const SizedBox(height: 16),
          Text(
            isFrench ? 'Document traduit!' : 'Document translated!',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (state.detectedSourceLang != null) ...[
            const SizedBox(height: 8),
            Text(
              '${isFrench ? "Langue détectée" : "Detected language"}: '
              '${_languageName(state.detectedSourceLang!, isFrench)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.vsGray),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.downloadUrl == null
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final err = await downloadAndOpenFile(
                        state.downloadUrl!,
                        state.outputName ?? 'translated',
                      );
                      if (err != null) {
                        messenger.showSnackBar(SnackBar(
                          content: Text(isFrench
                              ? 'Téléchargement échoué.'
                              : 'Download failed.'),
                          backgroundColor: AppColors.vsError,
                        ));
                      }
                    },
              icon: const Icon(Icons.download),
              label: Text(
                isFrench ? 'Télécharger le document' : 'Download Document',
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity, child: _saveToDriveButton(context)),
          if (state.driveSaveStatus == 'failed' && state.errorMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              isFrench
                  ? 'Échec de l\'enregistrement sur Drive'
                  : 'Could not save to Drive',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.vsError),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: notifier.reset,
              child: Text(isFrench ? 'Traduire un autre' : 'Translate Another'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveToDriveButton(BuildContext context) {
    switch (state.driveSaveStatus) {
      case 'saving':
        return OutlinedButton.icon(
          onPressed: null,
          icon: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          label: Text(isFrench ? 'Enregistrement...' : 'Saving to Drive...'),
        );
      case 'saved':
        return OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.cloud_done, color: AppColors.vsSuccess),
          label: Text(
            isFrench ? 'Enregistré sur Drive' : 'Saved to Google Drive',
            style: const TextStyle(color: AppColors.vsSuccess),
          ),
        );
      default:
        return OutlinedButton.icon(
          onPressed: notifier.saveToDrive,
          icon: const Icon(Icons.cloud_upload),
          label: Text(
            isFrench ? 'Enregistrer sur Google Drive' : 'Save to Google Drive',
          ),
        );
    }
  }
}

// ── Shared language picker ──────────────────────────────────────────────────

class _LanguageSheet extends StatefulWidget {
  const _LanguageSheet({
    required this.isSource,
    required this.isFrench,
    required this.onSelect,
  });

  final bool isSource;
  final bool isFrench;
  final void Function(String code) onSelect;

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _search.isEmpty
        ? kAllLanguages
        : kAllLanguages.where((l) {
            final q = _search.toLowerCase();
            return l.nameEn.toLowerCase().contains(q) ||
                l.nameFr.toLowerCase().contains(q) ||
                l.code.toLowerCase().contains(q);
          }).toList();

    final priority = filtered
        .where((l) => kPriorityLanguages.any((p) => p.code == l.code))
        .toList();
    final others = filtered
        .where((l) => !kPriorityLanguages.any((p) => p.code == l.code))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.vsLightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.isFrench
                      ? 'Rechercher une langue...'
                      : 'Search languages...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.vsBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
                      title: Text(
                          widget.isFrench ? 'Détection auto' : 'Auto-detect'),
                      onTap: () => widget.onSelect('auto'),
                    ),
                    const Divider(),
                  ],
                  ...priority.map((l) => ListTile(
                        title: Text(widget.isFrench ? l.nameFr : l.nameEn),
                        subtitle: Text(l.code.toUpperCase()),
                        onTap: () => widget.onSelect(l.code),
                      )),
                  if (priority.isNotEmpty) const Divider(),
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
    orElse: () =>
        Language(code: code, nameEn: code.toUpperCase(), nameFr: code.toUpperCase()),
  );
  return isFrench ? lang.nameFr : lang.nameEn;
}

String _formatSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024).toStringAsFixed(1)} KB';
}
