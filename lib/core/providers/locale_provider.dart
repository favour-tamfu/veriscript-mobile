import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  bool _hydrated = false;

  @override
  Locale build() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final fallback = deviceLocale.languageCode.toLowerCase().startsWith('fr')
        ? const Locale('fr')
        : const Locale('en');

    if (!_hydrated) {
      _hydrated = true;
      Future<void>.microtask(_restoreSavedLocale);
    }

    return fallback;
  }

  Future<void> setLocale(Locale locale) async {
    state = Locale(locale.languageCode);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_locale', state.languageCode);
  }

  Future<void> _restoreSavedLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString('app_locale');
    if (savedCode == null || savedCode.isEmpty) {
      return;
    }

    state = Locale(savedCode);
  }
}
