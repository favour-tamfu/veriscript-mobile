import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

class NotificationService {
  static const _channelId = 'veriscipt_main';
  static const _channelName = 'VeriScript';
  static const _channelDesc = 'Document processing notifications';

  final _plugin = FlutterLocalNotificationsPlugin();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Store payload for navigator to pick up
    _pendingPayload = response.payload;
  }

  String? _pendingPayload;

  String? consumePendingPayload() {
    final p = _pendingPayload;
    _pendingPayload = null;
    return p;
  }

  Future<void> showScanComplete({
    required String documentName,
    required double similarityPct,
    required String reportId,
  }) async {
    await _plugin.show(
      _stableId(reportId),
      'Scan Complete',
      '"$documentName" — Similarity: ${similarityPct.round()}%',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: '/scanner/result/$reportId',
    );
  }

  Future<void> showConversionComplete({
    required String documentName,
    required String toFormat,
    required String jobId,
  }) async {
    await _plugin.show(
      _stableId(jobId),
      'Conversion Complete',
      '"$documentName" converted to ${toFormat.toUpperCase()} successfully',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
        ),
      ),
    );
  }

  Future<void> showTranslationComplete({
    required String sourceLang,
    required String targetLang,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Translation Complete',
      '${sourceLang.toUpperCase()} → ${targetLang.toUpperCase()} translation ready',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
        ),
      ),
    );
  }

  Future<void> showSyncComplete(int count) async {
    if (count <= 0) return;
    await _plugin.show(
      0xCAFE,
      'Sync Complete',
      'Synced $count document${count == 1 ? '' : 's'} from offline session',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
        ),
      ),
    );
  }

  int _stableId(String id) {
    // Map a string ID to a stable int notification ID
    return id.hashCode.abs() % 100000;
  }
}
