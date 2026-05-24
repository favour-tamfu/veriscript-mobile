import 'package:flutter/material.dart';

import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_empty_state.dart';

class OcrScreen extends StatelessWidget {
  const OcrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Numériseur OCR' : 'OCR Scanner'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: VsEmptyState(
          lottieAsset: 'assets/animations/empty.json',
          title: isFrench ? 'Numériseur OCR' : 'OCR Scanner',
          subtitle: isFrench
              ? 'Disponible en Phase 2 — numérisez des documents physiques avec votre caméra'
              : 'Coming in Phase 2 — scan physical documents with your camera',
        ),
      ),
    );
  }
}
