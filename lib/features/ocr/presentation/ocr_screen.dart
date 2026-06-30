import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_button.dart';
import '../../../core/widgets/vs_error_view.dart';
import 'ocr_notifier.dart';

class OcrScreen extends ConsumerWidget {
  const OcrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final state = ref.watch(ocrNotifierProvider);
    final notifier = ref.read(ocrNotifierProvider.notifier);

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Numériseur OCR' : 'OCR Scanner'),
      body: _buildBody(context, ref, state, notifier, isFrench),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    OcrState state,
    OcrNotifier notifier,
    bool isFrench,
  ) {
    if (state.ocrStatus == 'failed') {
      return VsErrorView(
        message: state.errorMessage ?? 'An error occurred',
        onRetry: notifier.reset,
      );
    }

    if (state.ocrStatus == 'processing') {
      return _buildProcessing(context, state, isFrench);
    }

    if (state.ocrStatus == 'done') {
      return _buildResult(context, ref, state, notifier, isFrench);
    }

    return _buildSourceSelection(context, notifier, isFrench);
  }

  Widget _buildSourceSelection(BuildContext context, OcrNotifier notifier, bool isFrench) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info card
          Container(
            decoration: BoxDecoration(
              color: AppColors.vsAccent.withValues(alpha: 0.1),
              border: const Border(left: BorderSide(color: AppColors.vsAccent, width: 4)),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFrench
                      ? 'Numérisez tout document physique avec votre caméra'
                      : 'Scan any physical document with your camera',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  isFrench
                      ? 'Fonctionne mieux avec: texte imprimé, notes de cours, livres, polycopiés'
                      : 'Works best with: printed text, lecture notes, books, handouts',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.lock, color: AppColors.vsSuccess, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isFrench
                            ? 'Traitement sur l\'appareil — rien ne quitte votre téléphone'
                            : 'On-device processing — nothing leaves your phone',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsSuccess),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          VsButton.primary(
            label: isFrench ? 'Prendre une photo' : 'Take Photo',
            icon: Icons.camera_alt_rounded,
            onPressed: notifier.captureFromCamera,
          ),
          const SizedBox(height: 12),
          VsButton.secondary(
            label: isFrench ? 'Choisir dans la galerie' : 'Choose from Gallery',
            onPressed: notifier.pickFromGallery,
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              isFrench
                  ? 'Supporté: scripts latins, texte imprimé en 50+ langues'
                  : 'Supported: Latin scripts, printed text in 50+ languages',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing(BuildContext context, OcrState state, bool isFrench) {
    return Stack(
      children: [
        if (state.imageFile != null)
          Opacity(
            opacity: 0.3,
            child: Image.file(
              state.imageFile!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(strokeWidth: 4, color: AppColors.vsAccent),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.vsPrimary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFrench ? 'Lecture de votre document...' : 'Reading your document...',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResult(
    BuildContext context,
    WidgetRef ref,
    OcrState state,
    OcrNotifier notifier,
    bool isFrench,
  ) {
    return Column(
      children: [
        // Image preview
        if (state.imageFile != null)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Image.file(
              state.imageFile!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isFrench ? 'Texte reconnu' : 'Recognised Text',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.vsAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${state.recognisedText.length} chars',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(state.isEditing ? Icons.done : Icons.edit),
                      onPressed: notifier.toggleEdit,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (state.recognisedText.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      isFrench
                          ? 'Aucun texte détecté. Essayez un meilleur éclairage ou une image plus nette.'
                          : 'No text detected. Try better lighting or a clearer image.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.vsGray),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.vsBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      maxLines: null,
                      readOnly: !state.isEditing,
                      controller: TextEditingController(text: state.recognisedText),
                      onChanged: notifier.updateText,
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                const SizedBox(height: 16),
                // Action row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.copy, size: 18),
                        label: Text(isFrench ? 'Copier' : 'Copy'),
                        onPressed: () async {
                          await notifier.copyText();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(isFrench ? 'Copié!' : 'Copied!')),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.translate, size: 18),
                        label: Text(isFrench ? 'Traduire' : 'Translate'),
                        onPressed: () {
                          context.push(AppRoutes.translator, extra: {
                            'initialText': state.recognisedText,
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: Text(isFrench ? 'Numériser à nouveau' : 'Scan Again'),
                        onPressed: notifier.reset,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
