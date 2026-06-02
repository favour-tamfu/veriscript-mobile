import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_button.dart';
import '../../../core/widgets/vs_card.dart';
import '../../../core/widgets/vs_error_view.dart';
import '../data/scan_repository.dart';
import 'scanner_notifier.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  int _statusMessageIndex = 0;
  Timer? _statusTimer;

  static const _statusMessagesEn = [
    'Uploading document...',
    'Scanning against web sources...',
    'Checking academic databases...',
    'Generating your report...',
  ];
  static const _statusMessagesFr = [
    'Téléchargement du document...',
    'Analyse contre les sources web...',
    'Vérification des bases de données académiques...',
    'Génération de votre rapport...',
  ];

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void _startStatusCycle() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _statusMessageIndex =
              (_statusMessageIndex + 1) % _statusMessagesEn.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final state = ref.watch(scannerNotifierProvider);
    final notifier = ref.read(scannerNotifierProvider.notifier);

    // Watch for done state → navigate to result
    ref.listen<ScannerState>(scannerNotifierProvider, (prev, next) {
      if (next.scanStatus == 'done' && next.currentReportId != null) {
        context.push('/scanner/result/${next.currentReportId}');
        notifier.reset();
      }
    });

    final isScanning = state.scanStatus == 'uploading' || state.scanStatus == 'scanning';

    if (isScanning && _statusTimer == null) {
      _startStatusCycle();
    } else if (!isScanning) {
      _statusTimer?.cancel();
      _statusTimer = null;
      _statusMessageIndex = 0;
    }

    return PopScope(
      canPop: !isScanning,
      child: Scaffold(
        appBar: VsAppBar(
          title: isFrench ? 'Vérification de plagiat' : 'Plagiarism Check',
        ),
        body: _buildBody(context, state, notifier, isFrench),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ScannerState state,
    ScannerNotifier notifier,
    bool isFrench,
  ) {
    if (state.scanStatus == 'quota_exceeded') {
      return _buildQuotaExceeded(context, isFrench);
    }

    if (state.scanStatus == 'failed') {
      return VsErrorView(
        message: state.errorMessage ?? 'An error occurred',
        onRetry: notifier.reset,
      );
    }

    if (state.scanStatus == 'uploading' || state.scanStatus == 'scanning') {
      return _buildScanning(context, state, notifier, isFrench);
    }

    return _buildIdle(context, state, notifier, isFrench);
  }

  Widget _buildIdle(
    BuildContext context,
    ScannerState state,
    ScannerNotifier notifier,
    bool isFrench,
  ) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quota bar
        if (userId != null)
          FutureBuilder<bool>(
            future: ref.read(scanRepositoryProvider).canScan(userId),
            builder: (context, snapshot) {
              return _buildQuotaBar(context, snapshot.data ?? true, isFrench);
            },
          ),
        const SizedBox(height: 16),

        // Upload area
        GestureDetector(
          onTap: state.selectedFile == null ? () => notifier.pickDocument() : null,
          child: CustomPaint(
            painter: _DashedBorderPainter(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.document_scanner_rounded, size: 72, color: AppColors.vsAccent),
                  const SizedBox(height: 16),
                  Text(
                    isFrench ? 'Appuyez pour importer un document' : 'Tap to upload a document',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PDF, DOCX or TXT · Max 10MB',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isFrench
                        ? 'Votre document est analysé contre des milliards de sources'
                        : 'Your document is scanned against billions of sources',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        // File info card
        if (state.selectedFile != null) ...[
          const SizedBox(height: 16),
          VsCard(
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_rounded, color: AppColors.vsAccent, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.fileName ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatSize(state.fileSizeBytes ?? 0),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if ((state.fileSizeBytes ?? 0) > 3 * 1024 * 1024) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.vsSurface,
                border: Border.all(color: AppColors.vsWarning),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.data_usage, color: AppColors.vsWarning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isFrench
                          ? 'Cela peut consommer des données mobiles importantes'
                          : 'This may use significant mobile data',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsWarning),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          VsCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.detectAi,
              onChanged: notifier.setDetectAi,
              activeThumbColor: AppColors.vsAccent,
              title: Text(
                isFrench ? 'Détecter le contenu IA' : 'Detect AI content',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isFrench
                    ? 'Analyse aussi le texte généré par IA (utilise un crédit IA)'
                    : 'Also scan for AI-generated text (uses an AI credit)',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.vsGray),
              ),
            ),
          ),
          const SizedBox(height: 16),
          VsButton.primary(
            label: isFrench ? 'Analyser le plagiat' : 'Scan for Plagiarism',
            onPressed: notifier.startScan,
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: notifier.pickDocument,
              child: Text(isFrench ? 'Choisir un autre fichier' : 'Choose different file'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuotaBar(BuildContext context, bool canScan, bool isFrench) {
    if (!canScan) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.vsSurface,
          border: Border.all(color: AppColors.vsError),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.block, color: AppColors.vsError),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isFrench
                    ? 'Limite d\'analyses atteinte pour ce mois'
                    : 'Scan limit reached for this month',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.vsError,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildScanning(
    BuildContext context,
    ScannerState state,
    ScannerNotifier notifier,
    bool isFrench,
  ) {
    final messages = isFrench ? _statusMessagesFr : _statusMessagesEn;
    final message = messages[_statusMessageIndex];
    final progress = state.progressEstimate ?? 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progress > 0 ? progress : null,
                      strokeWidth: 6,
                      color: AppColors.vsAccent,
                    ),
                  ),
                  if (progress > 0)
                    Text(
                      '${(progress * 100).round()}%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.vsPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                message,
                key: ValueKey<String>(message),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isFrench
                  ? 'Cela peut prendre une à deux minutes — gardez l\'application ouverte'
                  : 'This can take a minute or two — keep the app open',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: notifier.cancel,
              child: Text(isFrench ? 'Annuler' : 'Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotaExceeded(BuildContext context, bool isFrench) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.vsSurface,
            border: Border.all(color: AppColors.vsError),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, color: AppColors.vsError, size: 48),
              const SizedBox(height: 16),
              Text(
                isFrench
                    ? 'Limite d\'analyses atteinte pour ce mois'
                    : 'Scan limit reached for this month',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isFrench
                    ? 'Passez à VeriScript Plus pour des analyses illimitées.'
                    : 'Upgrade to VeriScript Plus for unlimited scans.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.vsGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024).toStringAsFixed(1)} KB';
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
    final rect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16));
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
