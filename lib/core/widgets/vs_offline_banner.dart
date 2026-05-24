import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../providers/connectivity_provider.dart';

class VsOfflineBanner extends ConsumerWidget {
  const VsOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOffline ? 40 : 0,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isOffline ? 12 : 0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isOffline
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.offlineBanner,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )
          : null,
    );
  }
}
