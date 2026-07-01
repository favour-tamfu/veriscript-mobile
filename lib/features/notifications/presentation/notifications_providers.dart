import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/notifications_repository.dart';
import '../domain/app_notification.dart';

/// Notifications for the signed-in user, newest first.
final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  return ref.watch(notificationsRepositoryProvider).list(userId);
});

/// Unread count, used for the home-screen bell badge.
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final async = ref.watch(notificationsProvider);
  return async.asData?.value.where((n) => !n.isRead).length ?? 0;
});

/// Adds a notification for the current user and refreshes the list. Safe to call
/// from any notifier (pass its `ref`). No-ops if signed out.
Future<void> pushAppNotification(
  Ref ref, {
  required String title,
  required String body,
  required String type,
}) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return;
  final notification = AppNotification(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    title: title,
    body: body,
    type: type,
    createdAt: DateTime.now(),
  );
  await ref.read(notificationsRepositoryProvider).add(userId, notification);
  ref.invalidate(notificationsProvider);
}
