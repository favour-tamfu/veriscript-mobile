import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_button.dart';
import '../../../core/widgets/vs_empty_state.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Scaffold(
      appBar: VsAppBar(
        title: isFrench ? 'Vérification de plagiat' : 'Plagiarism Check',
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: VsEmptyState(
          lottieAsset: 'assets/animations/empty.json',
          title: isFrench ? 'Vérificateur de plagiat' : 'Plagiarism Scanner',
          subtitle: isFrench
              ? 'Disponible en Phase 2 — importez un document pour vérifier le plagiat'
              : 'Coming in Phase 2 — upload a document to check for plagiarism',
          action: VsButton.secondary(
            label: isFrench ? 'En savoir plus' : 'Learn more',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: AppColors.vsSurface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isFrench ? 'Bientôt disponible' : 'Coming soon',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isFrench
                              ? 'Cette fonctionnalité enverra votre document à Supabase pour analyser le plagiat et produire un rapport détaillé.'
                              : 'This feature will send your document through Supabase to analyze plagiarism and produce a detailed originality report.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
