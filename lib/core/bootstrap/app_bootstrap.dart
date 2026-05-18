import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

class AppBootstrapResult {
  const AppBootstrapResult({
    required this.config,
    required this.notes,
  });

  final AppConfig config;
  final List<String> notes;
}

abstract final class AppBootstrap {
  static Future<AppBootstrapResult> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    final config = AppConfig.fromEnvironment();
    final notes = <String>[];

    if (config.hasSupabase) {
      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabaseAnonKey,
      );
    } else {
      notes.add('Supabase credentials missing. Falling back to local auth.');
    }

    final revenueCatKey = config.activeRevenueCatKey;
    if (revenueCatKey != null) {
      await Purchases.setLogLevel(LogLevel.warn);
      await Purchases.configure(PurchasesConfiguration(revenueCatKey));
    } else {
      notes.add('RevenueCat key missing. Paywall will stay in preview mode.');
    }

    if (!config.hasConverterEndpoint) {
      notes.add(
        'Converter endpoint missing. Conversion requests will be stored locally until a backend is configured.',
      );
    }

    return AppBootstrapResult(config: config, notes: notes);
  }
}
