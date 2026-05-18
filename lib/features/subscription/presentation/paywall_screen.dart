import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../application/subscription_controller.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  static const routeName = 'paywall';
  static const routePath = '/paywall';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final paywallAsync = ref.watch(paywallStateProvider);
    final purchaseState = ref.watch(purchaseControllerProvider);

    return AppShell(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paywallTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallBody,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
      child: paywallAsync.when(
        data: (paywall) {
          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: paywall.isSubscriber
                      ? const Color(0xFFE7F7F4)
                      : const Color(0xFFFFF6E5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(paywall.message),
              ),
              const SizedBox(height: 18),
              const _PlanComparisonTable(),
              const SizedBox(height: 18),
              if (paywall.packages.isEmpty)
                Text(
                  l10n.paywallNoPackages,
                  textAlign: TextAlign.center,
                )
              else
                ...paywall.packages.map(
                  (package) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              package.price,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: purchaseState.isLoading
                                  ? null
                                  : () async {
                                      final message = await ref
                                          .read(
                                            purchaseControllerProvider.notifier,
                                          )
                                          .purchasePackage(package.identifier);
                                      if (message == null || !context.mounted) {
                                        return;
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            SnackBar(content: Text(message)),
                                          );
                                    },
                              child: Text(l10n.paywallUnlock),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: purchaseState.isLoading
                    ? null
                    : () async {
                        final message = await ref
                            .read(purchaseControllerProvider.notifier)
                            .restorePurchases();
                        if (message == null || !context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      },
                child: Text(l10n.paywallRestore),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _PlanComparisonTable extends StatelessWidget {
  const _PlanComparisonTable();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Free vs Plus',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const _PlanRow(label: 'Scans / month', freeValue: '3', plusValue: 'Unlimited'),
            const _PlanRow(label: 'Conversions / month', freeValue: '5', plusValue: 'Unlimited'),
            const _PlanRow(label: 'Offline docs', freeValue: '10', plusValue: '50'),
            const _PlanRow(label: 'PDF export', freeValue: 'No', plusValue: 'Yes'),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.label,
    required this.freeValue,
    required this.plusValue,
  });

  final String label;
  final String freeValue;
  final String plusValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(width: 72, child: Text(freeValue, textAlign: TextAlign.center)),
          SizedBox(width: 88, child: Text(plusValue, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
