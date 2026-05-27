import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../data/quota_repository.dart';

class QuotaBarWidget extends StatelessWidget {
  const QuotaBarWidget({
    super.key,
    required this.quotaAsync,
    required this.isFrench,
    required this.onUpgrade,
  });

  final AsyncValue<UsageQuota> quotaAsync;
  final bool isFrench;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return quotaAsync.when(
      data: (quota) {
        final bars = <_QuotaBarData>[
          _QuotaBarData(
            label: isFrench ? 'Vérifications de plagiat' : 'Plagiarism Scans',
            limit: 3,
            used: quota.scansUsed,
          ),
          _QuotaBarData(
            label: isFrench ? 'Conversions de fichiers' : 'File Conversions',
            limit: 5,
            used: quota.conversionsUsed,
          ),
          _QuotaBarData(
            label: isFrench ? 'Scans OCR' : 'OCR Scans',
            limit: 10,
            used: quota.ocrUsed,
          ),
          _QuotaBarData(
            label: isFrench ? 'Traduction' : 'Translation',
            limit: 5000,
            used: quota.charsTranslated,
          ),
        ];
        final isAtLimit = bars.any((bar) => bar.percent >= 1);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isFrench ? 'Utilisation mensuelle' : 'Monthly Usage',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.vsLightGray,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isFrench ? 'Plan gratuit' : 'Free plan',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.vsGray,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final bar in bars) ...[
                  Text(bar.label),
                  const SizedBox(height: 6),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 10,
                    percent: bar.percent.clamp(0, 1),
                    barRadius: const Radius.circular(999),
                    backgroundColor: AppColors.vsLightGray,
                    progressColor: _progressColor(bar.percent),
                    center: null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${bar.used} / ${bar.limit}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.vsGray,
                        ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (quota.bonusScans > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.vsWarning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.vsWarning.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars_rounded,
                            size: 16, color: AppColors.vsWarning),
                        const SizedBox(width: 6),
                        Text(
                          isFrench
                              ? '${quota.bonusScans} scans bonus disponibles'
                              : '${quota.bonusScans} bonus scans available',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.vsWarning,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (isAtLimit)
                  TextButton(
                    onPressed: onUpgrade,
                    child: Text(
                      isFrench
                          ? 'Mettre à niveau — accès illimité'
                          : 'Upgrade — unlimited access',
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => Shimmer.fromColors(
        baseColor: AppColors.vsLightGray,
        highlightColor: Colors.white,
        child: Card(
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: Container(color: AppColors.vsLightGray),
          ),
        ),
      ),
    );
  }
}

class _QuotaBarData {
  const _QuotaBarData({
    required this.label,
    required this.limit,
    required this.used,
  });

  final String label;
  final int limit;
  final int used;

  double get percent => limit == 0 ? 0 : used / limit;
}

Color _progressColor(double percent) {
  if (percent >= 1) {
    return AppColors.vsError;
  }
  if (percent >= 0.8) {
    return AppColors.vsWarning;
  }
  return AppColors.vsAccent;
}
