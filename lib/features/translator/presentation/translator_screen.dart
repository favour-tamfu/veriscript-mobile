import 'package:flutter/material.dart';

import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_empty_state.dart';

class TranslatorScreen extends StatelessWidget {
  const TranslatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Traducteur' : 'Translator'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: VsEmptyState(
          lottieAsset: 'assets/animations/empty.json',
          title: isFrench ? 'Traducteur' : 'Translator',
          subtitle: isFrench
              ? 'Disponible en Phase 2 — traduisez des documents en 100+ langues'
              : 'Coming in Phase 2 — translate documents into 100+ languages',
        ),
      ),
    );
  }
}
