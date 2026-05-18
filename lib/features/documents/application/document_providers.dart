import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';

final recentDocumentsProvider = StreamProvider<List<DocumentRecord>>((ref) {
  return ref.watch(appDatabaseProvider).watchRecentDocuments();
});

final allDocumentsProvider = StreamProvider<List<DocumentRecord>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllDocuments();
});
