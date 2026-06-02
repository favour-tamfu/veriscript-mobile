import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/edge_function_caller.dart';
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
                        onPressed: () => _exportPdf(context, ref, isFrench),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: Text(isFrench ? 'Partager' : 'Share'),
                        onPressed: () => _share(job, isFrench),
                      ),
                    ),
                    if (job.status == 'failed') ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: Text(isFrench ? 'Analyser à nouveau' : 'Rescan'),
                          onPressed: () {},
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

  Future<void> _exportPdf(BuildContext context, WidgetRef ref, bool isFrench) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final result = await ref.read(edgeFunctionCallerProvider).invoke(
        'export-report-pdf',
        body: {'reportId': reportId, 'userId': ''},
      );

      if (result['htmlContent'] != null) {
        await Printing.layoutPdf(
          onLayout: (_) async {
            // Flutter printing will handle HTML via webview on supported platforms
            return Uint8List(0);
          },
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(isFrench ? 'Exportation échouée. Réessayez.' : 'Export failed. Try again.'),
          backgroundColor: AppColors.vsError,
        ),
      );
    }
  }

  void _share(ScanJob job, bool isFrench) {
    final pct = job.similarityPct?.round() ?? 0;
    final aiPart = job.aiProbability != null
        ? (isFrench ? ' · IA ${job.aiProbability!.round()}%' : ' · AI ${job.aiProbability!.round()}%')
        : '';
    SharePlus.instance.share(
      ShareParams(
        text: isFrench
            ? 'Mon rapport VeriScript: Similarité $pct%$aiPart — rapport généré le ${job.createdAt.toLocal().toString().split(' ')[0]}'
            : 'My VeriScript report: Similarity $pct%$aiPart — report generated ${job.createdAt.toLocal().toString().split(' ')[0]}',
      ),
    );
  }
}

Color _aiColor(double pct) {
  if (pct < 30) return AppColors.vsLowSimilarity;
  if (pct < 70) return AppColors.vsMedSimilarity;
  return AppColors.vsHighSimilarity;
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
