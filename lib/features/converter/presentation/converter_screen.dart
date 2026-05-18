import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../application/converter_controller.dart';

class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  static const routeName = 'converter';
  static const routePath = '/converter';

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  String _targetFormat = 'pdf';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actionState = ref.watch(converterControllerProvider);
    final config = ref.watch(appConfigProvider);

    return AppShell(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.converterTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.converterBody,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
      child: ListView(
        children: [
          if (!config.hasConverterEndpoint)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.converterSetupNotice,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            l10n.converterTargetFormat,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'pdf', label: Text('PDF')),
              ButtonSegment(value: 'docx', label: Text('DOCX')),
              ButtonSegment(value: 'txt', label: Text('TXT')),
            ],
            selected: {_targetFormat},
            onSelectionChanged: (value) {
              setState(() {
                _targetFormat = value.first;
              });
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: actionState.isLoading
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final message = await ref
                        .read(converterControllerProvider.notifier)
                        .pickAndConvert(_targetFormat);
                    if (!mounted || message == null) {
                      return;
                    }

                    messenger.showSnackBar(SnackBar(content: Text(message)));
                  },
            icon: actionState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file_rounded),
            label: Text(l10n.converterPickFile),
          ),
        ],
      ),
    );
  }
}
