import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final supabaseStorageProvider = Provider<SupabaseStorageClient>(
  (ref) => Supabase.instance.client.storage,
);
