import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/auth_repository.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';

final appConfigProvider = Provider<AppConfig>(
  (_) => throw UnimplementedError('AppConfig override missing.'),
);

final bootstrapNotesProvider = Provider<List<String>>((_) => const []);

final secureStorageProvider = Provider<FlutterSecureStorage>((_) {
  return const FlutterSecureStorage();
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);

  if (config.hasSupabase) {
    return SupabaseAuthRepository(Supabase.instance.client);
  }

  final repository = LocalAuthRepository(ref.watch(secureStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});
