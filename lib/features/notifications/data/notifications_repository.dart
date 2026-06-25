import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_notification.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(),
);

/// Persists in-app notifications locally (per user) in SharedPreferences.
class NotificationsRepository {
  static const _maxStored = 50;

  String _key(String userId) => 'notifications_$userId';

  Future<List<AppNotification>> list(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> _save(String userId, List<AppNotification> items) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = items.take(_maxStored).toList();
    await prefs.setString(
      _key(userId),
      jsonEncode(trimmed.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> add(String userId, AppNotification notification) async {
    final items = await list(userId);
    await _save(userId, [notification, ...items]);
  }

  Future<void> markAllRead(String userId) async {
    final items = await list(userId);
    if (items.every((i) => i.isRead)) return;
    await _save(userId, items.map((i) => i.copyWith(isRead: true)).toList());
  }

  Future<void> clear(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(userId));
  }
}
