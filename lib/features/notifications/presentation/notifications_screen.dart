import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_empty_state.dart';
import '../data/notifications_repository.dart';
import '../domain/app_notification.dart';
import 'notifications_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Opening the screen clears the unread badge.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;
      await ref.read(notificationsRepositoryProvider).markAllRead(userId);
      if (mounted) ref.invalidate(notificationsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: VsAppBar(
        title: isFrench ? 'Notifications' : 'Notifications',
        actions: [
          if ((async.asData?.value.isNotEmpty ?? false))
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: isFrench ? 'Tout effacer' : 'Clear all',
              onPressed: () async {
                final userId = Supabase.instance.client.auth.currentUser?.id;
                if (userId == null) return;
                await ref.read(notificationsRepositoryProvider).clear(userId);
                ref.invalidate(notificationsProvider);
              },
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.vsAccent),
        ),
        error: (_, __) => Center(
          child: Text(isFrench ? 'Une erreur est survenue' : 'Something went wrong'),
        ),
        data: (items) {
          if (items.isEmpty) {
            return VsEmptyState(
              lottieAsset: 'assets/animations/empty.json',
              title: isFrench ? 'Aucune notification' : 'No notifications',
              subtitle: isFrench
                  ? 'Vos activités terminées apparaîtront ici.'
                  : 'Your completed activity will show up here.',
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) =>
                _tile(context, items[index], isFrench),
          );
        },
      ),
    );
  }

  Widget _tile(BuildContext context, AppNotification n, bool isFrench) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.vsAccent.withValues(alpha: 0.12),
        child: Icon(_iconFor(n.type), color: AppColors.vsAccent, size: 20),
      ),
      title: Text(
        n.title,
        style: TextStyle(
          fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
        ),
      ),
      subtitle: Text(n.body),
      trailing: Text(
        _relativeTime(n.createdAt, isFrench),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.vsGray),
      ),
    );
  }
}

IconData _iconFor(String type) {
  switch (type) {
    case 'scan':
      return Icons.document_scanner_rounded;
    case 'conversion':
      return Icons.swap_horiz_rounded;
    case 'translation':
      return Icons.translate_rounded;
    default:
      return Icons.notifications_rounded;
  }
}

String _relativeTime(DateTime time, bool isFrench) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return isFrench ? "maintenant" : 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return '${diff.inDays}j';
}
