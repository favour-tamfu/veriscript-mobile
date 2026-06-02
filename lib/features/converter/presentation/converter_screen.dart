import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_error_view.dart';
import '../../home/data/quota_repository.dart';
import '../data/conversion_repository.dart';
import '../domain/conversion_formats.dart';
import '../presentation/converter_notifier.dart';

class ConverterScreen extends ConsumerWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(converterNotifierProvider);
    final notifier = ref.read(converterNotifierProvider.notifier);
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Scaffold(
      appBar: AppBar(
        title: Text(isFrench ? 'Convertisseur de fichiers' : 'File Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildBody(context, ref, state, notifier, isFrench),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ConverterState state,
    ConverterNotifier notifier,
    bool isFrench,
  ) {
    if (state.jobStatus == 'quota_exceeded') {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, color: AppColors.vsError, size: 48),
              const SizedBox(height: 16),
              Text(
                isFrench
                    ? 'Limite de conversions atteinte'
                    : 'Conversion limit reached',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isFrench
                    ? 'Passez à VeriScript Plus pour des conversions illimitées.'
                    : 'Upgrade to VeriScript Plus for unlimited conversions.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.vsGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: notifier.reset,
                child: Text(isFrench ? 'Retour' : 'Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.jobStatus == 'idle' && state.selectedFile == null) {
      return Center(
        child: InkWell(
          onTap: () async {
            final file = await notifier.pickFile();
            if (file == null || !context.mounted) {
              return;
            }

            final isLargeFile = await file.length() > 5 * 1024 * 1024;
            if (!context.mounted) return;
            if (isLargeFile) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFrench
                        ? 'Fichier volumineux — cela peut consommer beaucoup de données mobiles'
                        : 'Large file — this may use significant mobile data',
                  ),
                ),
              );
            }
          },
          child: CustomPaint(
            painter: _DashedBorderPainter(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.upload_file_rounded,
                    size: 64,
                    color: AppColors.vsAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isFrench
                        ? 'Appuyez pour sélectionner un fichier'
                        : 'Tap to select a file',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isFrench
                        ? 'PDF, Word, images, tableurs et plus · Max 10 Mo'
                        : 'PDF, Word, images, spreadsheets & more · Max 10MB',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.vsGray),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (state.selectedFile != null && state.jobStatus == 'idle') {
      final file = state.selectedFile!;
      final availableFormats = targetFormatsFor(state.fromFormat ?? '');
      final conversionsUsed =
          ref.watch(quotaProvider).asData?.value.conversionsUsed ?? 0;
      final remaining =
          (kFreeConversionLimit - conversionsUsed).clamp(0, kFreeConversionLimit);

      return ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _iconForFormat(state.fromFormat ?? ''),
                    color: AppColors.vsAccent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(file.path.split(Platform.pathSeparator).last),
                        const SizedBox(height: 4),
                        Text(
                          _formatSize(file.lengthSync()),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.vsGray),
                        ),
                      ],
                    ),
                  ),
                  Chip(label: Text((state.fromFormat ?? '').toUpperCase())),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isFrench ? 'Convertir en:' : 'Convert to:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableFormats
                .map(
                  (format) => FilterChip(
                    selected: state.toFormat == format,
                    selectedColor: AppColors.vsAccent,
                    labelStyle: TextStyle(
                      color: state.toFormat == format
                          ? Colors.white
                          : AppColors.vsDark,
                    ),
                    backgroundColor: AppColors.vsBackground,
                    label: Text(format.toUpperCase()),
                    onSelected: (_) => notifier.setTargetFormat(format),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            isFrench
                ? '$remaining sur $kFreeConversionLimit conversions gratuites restantes'
                : '$remaining of $kFreeConversionLimit free conversions remaining',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.vsGray),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.toFormat.isEmpty ? null : notifier.startConversion,
              child: Text(
                isFrench ? 'Convertir maintenant' : 'Convert Now',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: notifier.reset,
              child: Text(
                isFrench
                    ? 'Choisir un autre fichier'
                    : 'Choose different file',
              ),
            ),
          ),
        ],
      );
    }

    if (state.jobStatus == 'done') {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.vsSuccess,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              isFrench ? 'Conversion terminée!' : 'Conversion complete!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.downloadUrl == null
                    ? null
                    : () async {
                        final uri = Uri.parse(state.downloadUrl!);
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                child: Text(
                  isFrench ? 'Télécharger le fichier' : 'Download File',
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: notifier.reset,
                child: Text(
                  isFrench ? 'Convertir un autre' : 'Convert Another',
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.jobStatus == 'failed') {
      return VsErrorView(
        message: state.errorMessage ?? '',
        onRetry: notifier.startConversion,
      );
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
            state.jobStatus == 'uploading'
                ? (isFrench
                    ? 'Téléchargement de votre fichier...'
                    : 'Uploading your file...')
                : (isFrench
                    ? 'Conversion de votre document...'
                    : 'Converting your document...'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final paint = Paint()
      ..color = AppColors.vsGray
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );

    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

IconData _iconForFormat(String format) {
  switch (format) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'docx':
      return Icons.description;
    default:
      return Icons.article;
  }
}

String _formatSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024).toStringAsFixed(1)} KB';
}
