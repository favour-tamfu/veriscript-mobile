import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/providers/app_providers.dart';

Future<void> main() async {
  final bootstrap = await AppBootstrap.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(bootstrap.config),
        bootstrapNotesProvider.overrideWithValue(bootstrap.notes),
      ],
      child: const VeriScriptApp(),
    ),
  );
}
