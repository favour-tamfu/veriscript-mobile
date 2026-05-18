import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

const _onboardingStorageKey = 'onboarding_complete_v1';

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, bool>(
      OnboardingController.new,
    );

class OnboardingController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final raw = await ref
        .read(secureStorageProvider)
        .read(key: _onboardingStorageKey);
    return raw == 'true';
  }

  Future<void> markComplete() async {
    await ref
        .read(secureStorageProvider)
        .write(key: _onboardingStorageKey, value: 'true');
    state = const AsyncData(true);
  }
}
