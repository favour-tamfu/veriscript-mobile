import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/supabase/supabase_providers.dart';

final quotaRepositoryProvider = Provider<QuotaRepository>(
  (ref) => QuotaRepository(ref.watch(supabaseClientProvider)),
);

class UsageQuota {
  const UsageQuota({
    required this.scansUsed,
    required this.conversionsUsed,
    required this.ocrUsed,
    required this.charsTranslated,
    required this.periodStart,
  });

  final int scansUsed;
  final int conversionsUsed;
  final int ocrUsed;
  final int charsTranslated;
  final DateTime periodStart;
}

class QuotaRepository {
  QuotaRepository(this._client);

  final SupabaseClient _client;

  Future<UsageQuota> getQuota(String userId, {required bool isOffline}) async {
    if (isOffline) {
      return _fallbackQuota();
    }

    try {
      final data = await _client
          .from('usage_quotas')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        return _fallbackQuota();
      }

      return UsageQuota(
        scansUsed: (data['scans_used'] as num?)?.toInt() ?? 0,
        conversionsUsed: (data['conversions_used'] as num?)?.toInt() ?? 0,
        ocrUsed: (data['ocr_used'] as num?)?.toInt() ?? 0,
        charsTranslated: (data['chars_translated'] as num?)?.toInt() ?? 0,
        periodStart: DateTime.tryParse(
              data['period_start']?.toString() ?? '',
            ) ??
            DateTime(DateTime.now().year, DateTime.now().month, 1),
      );
    } catch (_) {
      return _fallbackQuota();
    }
  }

  UsageQuota _fallbackQuota() {
    final now = DateTime.now();
    return UsageQuota(
      scansUsed: 0,
      conversionsUsed: 0,
      ocrUsed: 0,
      charsTranslated: 0,
      periodStart: DateTime(now.year, now.month, 1),
    );
  }
}

final quotaProvider = FutureProvider<UsageQuota>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final userId = client.auth.currentUser?.id;
  if (userId == null) {
    return QuotaRepository(client).getQuota('', isOffline: true);
  }

  return ref.watch(quotaRepositoryProvider).getQuota(
        userId,
        isOffline: ref.watch(isOfflineProvider),
      );
});
