import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListTile(
        title: const Text('Language / Langue'),
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
