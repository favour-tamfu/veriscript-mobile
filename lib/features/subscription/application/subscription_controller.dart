import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/providers/app_providers.dart';

class PaywallPackageViewModel {
  const PaywallPackageViewModel({
    required this.identifier,
    required this.title,
    required this.price,
  });

  final String identifier;
  final String title;
  final String price;
}

class PaywallState {
  const PaywallState({
    required this.isConfigured,
    required this.isSubscriber,
    required this.message,
    required this.packages,
  });

  final bool isConfigured;
  final bool isSubscriber;
  final String message;
  final List<PaywallPackageViewModel> packages;
}

final paywallStateProvider = FutureProvider<PaywallState>((ref) async {
  final config = ref.watch(appConfigProvider);

  if (!config.hasRevenueCat) {
    return const PaywallState(
      isConfigured: false,
      isSubscriber: false,
      message: 'RevenueCat keys are missing. This screen is running in preview mode.',
      packages: [],
    );
  }

  if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
    return const PaywallState(
      isConfigured: false,
      isSubscriber: false,
      message: 'RevenueCat purchases are only available on Android and iOS.',
      packages: [],
    );
  }

  final Offerings offerings = await Purchases.getOfferings();
  final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  final currentOffering = offerings.current;

  if (currentOffering == null) {
    return PaywallState(
      isConfigured: true,
      isSubscriber: customerInfo.activeSubscriptions.isNotEmpty,
      message: 'RevenueCat is connected but no active offering is available yet.',
      packages: const [],
    );
  }

  return PaywallState(
    isConfigured: true,
    isSubscriber: customerInfo.activeSubscriptions.isNotEmpty,
    message: 'Choose a plan to unlock higher conversion and offline limits.',
    packages: currentOffering.availablePackages
        .map(
          (package) => PaywallPackageViewModel(
            identifier: package.identifier,
            title: package.storeProduct.title,
            price: package.storeProduct.priceString,
          ),
        )
        .toList(),
  );
});

final purchaseControllerProvider =
    AsyncNotifierProvider<PurchaseController, void>(PurchaseController.new);

class PurchaseController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> purchasePackage(String identifier) async {
    state = const AsyncLoading();
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.availablePackages.firstWhere(
        (item) => item.identifier == identifier,
      );

      if (package == null) {
        state = const AsyncData(null);
        return 'No matching package was found.';
      }

      await Purchases.purchasePackage(package);
      ref.invalidate(paywallStateProvider);
      state = const AsyncData(null);
      return null;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return 'Purchase could not be completed.';
    }
  }

  Future<String?> restorePurchases() async {
    state = const AsyncLoading();
    try {
      await Purchases.restorePurchases();
      ref.invalidate(paywallStateProvider);
      state = const AsyncData(null);
      return null;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return 'Restore failed.';
    }
  }
}
