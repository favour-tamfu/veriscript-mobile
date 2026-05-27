import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../sync/sync_service.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) async* {
  final connectivity = Connectivity();
  ConnectivityResult? _lastResult;

  final initial = _mapConnectivityResults(await connectivity.checkConnectivity());
  _lastResult = initial;
  yield initial;

  await for (final results in connectivity.onConnectivityChanged) {
    final mapped = _mapConnectivityResults(results);
    // Trigger sync when going from offline to online
    if (_lastResult == ConnectivityResult.none && mapped != ConnectivityResult.none) {
      ref.read(syncServiceProvider).processQueue();
    }
    _lastResult = mapped;
    yield mapped;
  }
});

final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).maybeWhen(
        data: (result) => result == ConnectivityResult.none,
        orElse: () => false,
      );
});

ConnectivityResult _mapConnectivityResults(List<ConnectivityResult> results) {
  if (results.isEmpty || results.contains(ConnectivityResult.none)) {
    return ConnectivityResult.none;
  }

  return results.first;
}
