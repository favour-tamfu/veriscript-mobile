import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) async* {
  final connectivity = Connectivity();

  yield _mapConnectivityResults(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(_mapConnectivityResults);
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
