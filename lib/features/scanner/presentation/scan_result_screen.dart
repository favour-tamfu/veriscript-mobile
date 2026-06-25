import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_card.dart';
import '../../../core/widgets/vs_error_view.dart';
import '../data/scan_repository.dart';
import '../domain/scan_job.dart';

final scanResultProvider = FutureProvider.family<ScanJob, String>((ref, reportId) {
  return ref.watch(scanRepositoryProvider).getScanReport(reportId);
});

class ScanResultScreen extends ConsumerWidget {
  const ScanResultScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final reportAsync = ref.watch(scanResultProvider(reportId));

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Rapport d\'originalité' : 'Originality Report'),
      body: reportAsync.when(
        data: (job) => _buildContent(context, ref, job, isFrench),
        error: (e, _) => VsErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(scanResultProvider(reportId)),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.vsAccent)),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ScanJob job, bool isFrench) {
    final pct = job.similarityPct ?? 0.0;
    final color = _similarityColor(pct);
    final sources = job.sources ?? [];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Section 1: Similarity ring
                VsCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(
                                    value: pct,
                                    color: color,
                                    radius: 20,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    value: 100 - pct,
                                    color: AppColors.vsLightGray,
                                    radius: 20,
                                    showTitle: false,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${pct.round()}%',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        isFrench ? 'Score de similarité' : 'Similarity Score',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _riskLabel(pct, isFrench),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Section 1b: AI-generated content detection
                if (job.aiProbability != null) ...[
                  const SizedBox(height: 16),
                  _buildAiCard(context, job.aiProbability!, isFrench),
                ],
                const SizedBox(height: 16),

                // Section 2: Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: Text(isFrench ? 'Exporter PDF' : 'Export PDF'),
                        onPressed: () => _exportPdf(context, job, isFrench),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: Text(isFrench ? 'Partager' : 'Share'),
                        onPressed: () => _share(context, job, isFrench),
                      ),
                    ),
                    if (job.status == 'failed') ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: Text(isFrench ? 'Analyser à nouveau' : 'Rescan'),
                          onPressed: () => context.go(AppRoutes.scanner),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Section 3: Sources
                Row(
                  children: [
                    Text(
                      isFrench ? 'Sources correspondantes' : 'Matched Sources',
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
                        '${sources.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (sources.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      isFrench ? 'Aucune source spécifique identifiée' : 'No specific sources identified',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.vsGray),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sources.length,
                    itemBuilder: (context, index) {
                      return _buildSourceCard(context, sources[index], isFrench);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceCard(BuildContext context, ScanSource source, bool isFrench) {
    final color = _similarityColor(source.matchedPercent);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: VsCard(
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '${source.matchedPercent.round()}%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          title: Text(
            source.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            source.url,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.open_in_new, size: 20),
                onPressed: () async {
                  final uri = Uri.tryParse(source.url);
                  if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
              const Icon(Icons.expand_more),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  if (source.matchedWords != null)
                    Text(
                      '${source.matchedWords} matched words',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiCard(BuildContext context, double aiPct, bool isFrench) {
    final color = _aiColor(aiPct);
    return VsCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.auto_awesome_rounded, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFrench ? 'Contenu généré par IA' : 'AI-Generated Content',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  _aiLabel(aiPct, isFrench),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${aiPct.round()}%',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, ScanJob job, bool isFrench) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await _buildReportBytes(job, isFrench);
      await Printing.layoutPdf(
        name: 'VeriScript Report',
        onLayout: (_) async => bytes,
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(isFrench ? 'Exportation échouée. Réessayez.' : 'Export failed. Try again.'),
          backgroundColor: AppColors.vsError,
        ),
      );
    }
  }

  Future<void> _share(BuildContext context, ScanJob job, bool isFrench) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await _buildReportBytes(job, isFrench);
      final date = job.createdAt.toLocal().toString().split(' ')[0];
      await Printing.sharePdf(bytes: bytes, filename: 'veriscript-report-$date.pdf');
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(isFrench ? 'Partage échoué. Réessayez.' : 'Share failed. Try again.'),
          backgroundColor: AppColors.vsError,
        ),
      );
    }
  }

  Future<Uint8List> _buildReportBytes(ScanJob job, bool isFrench) async {
    final doc = pw.Document();
    final pct = job.similarityPct ?? 0.0;
    final ai = job.aiProbability;
    final sources = job.sources ?? [];
    final dateStr = job.createdAt.toLocal().toString().split(' ')[0];
    final simColor = _pdfRiskColor(pct);

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1A3C5E)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'VeriScript',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  isFrench ? "Rapport d'originalité" : 'Originality Report',
                  style: const pw.TextStyle(color: PdfColor.fromInt(0xFF2BBFAA), fontSize: 12),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(dateStr, style: const pw.TextStyle(color: PdfColors.grey, fontSize: 11)),
          pw.SizedBox(height: 20),
          pw.Text(
            isFrench ? 'Score de similarité' : 'Similarity Score',
            style: const pw.TextStyle(color: PdfColors.grey, fontSize: 12),
          ),
          pw.Text(
            '${pct.round()}%',
            style: pw.TextStyle(color: simColor, fontSize: 48, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            _riskLabel(pct, isFrench),
            style: pw.TextStyle(color: simColor, fontWeight: pw.FontWeight.bold),
          ),
          if (ai != null) ...[
            pw.SizedBox(height: 16),
            pw.Text(
              isFrench ? 'Contenu généré par IA' : 'AI-Generated Content',
              style: const pw.TextStyle(color: PdfColors.grey, fontSize: 12),
            ),
            pw.Text(
              '${ai.round()}%',
              style: pw.TextStyle(
                color: _pdfRiskColor(ai),
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(_aiLabel(ai, isFrench), style: pw.TextStyle(color: _pdfRiskColor(ai))),
          ],
          pw.SizedBox(height: 24),
          pw.Text(
            '${isFrench ? 'Sources correspondantes' : 'Matched Sources'} (${sources.length})',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          if (sources.isEmpty)
            pw.Text(
              isFrench ? 'Aucune source spécifique identifiée' : 'No specific sources identified',
              style: const pw.TextStyle(color: PdfColors.grey),
            )
          else
            ...sources.map(
              (s) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${s.matchedPercent.round()}%  ·  ${s.title}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                    ),
                    pw.Text(s.url, style: const pw.TextStyle(color: PdfColors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ),
          pw.SizedBox(height: 24),
          pw.Center(
            child: pw.Text(
              'Generated by VeriScript · $dateStr',
              style: const pw.TextStyle(color: PdfColors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }
}

Color _aiColor(double pct) {
  if (pct < 30) return AppColors.vsLowSimilarity;
  if (pct < 70) return AppColors.vsMedSimilarity;
  return AppColors.vsHighSimilarity;
}

PdfColor _pdfRiskColor(double pct) {
  if (pct < 30) return const PdfColor.fromInt(0xFF43A047);
  if (pct < 70) return const PdfColor.fromInt(0xFFFB8C00);
  return const PdfColor.fromInt(0xFFE53935);
}

String _aiLabel(double pct, bool isFrench) {
  if (pct < 30) {
    return isFrench ? 'Probablement écrit par un humain' : 'Likely human-written';
  }
  if (pct < 70) {
    return isFrench ? 'Contenu possiblement mixte' : 'Possibly mixed content';
  }
  return isFrench ? 'Probablement généré par IA' : 'Likely AI-generated';
}

Color _similarityColor(double pct) {
  if (pct < 30) return AppColors.vsLowSimilarity;
  if (pct < 70) return AppColors.vsMedSimilarity;
  return AppColors.vsHighSimilarity;
}

String _riskLabel(double pct, bool isFrench) {
  if (pct < 30) {
    return isFrench ? 'Risque faible — Probablement original' : 'Low Risk — Likely Original';
  }
  if (pct < 70) {
    return isFrench ? 'Risque moyen — Révision requise' : 'Medium Risk — Review Required';
  }
  return isFrench
      ? 'Risque élevé — Correspondances significatives'
      : 'High Risk — Significant Matches Found';
}
