import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListTile(
        title: Text(l10n.settingsLanguage),
        trailing: SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(value: 'en', label: Text('EN')),
            ButtonSegment<String>(value: 'fr', label: Text('FR')),
          ],
          selected: <String>{locale.languageCode},
          onSelectionChanged: (selection) {
            ref
                .read(localeProvider.notifier)
                .setLocale(Locale(selection.first));
          },
        ),
      ),
    );
  }
}
