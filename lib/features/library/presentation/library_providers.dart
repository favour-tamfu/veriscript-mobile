import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/library_repository.dart';
import '../domain/library_file.dart';

/// Files saved in the local library bucket for the signed-in user, newest first.
final libraryFilesProvider = FutureProvider<List<LibraryFile>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  return ref.watch(libraryRepositoryProvider).list(userId);
});
