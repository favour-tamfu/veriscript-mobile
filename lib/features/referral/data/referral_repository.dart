import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';

final referralRepositoryProvider = Provider<ReferralRepository>(
  (ref) => ReferralRepository(ref.watch(supabaseClientProvider)),
);

class ReferralRepository {
  ReferralRepository(this._client);

  final SupabaseClient _client;

  Future<String> getReferralCode(String userId) async {
    final data = await _client
        .from('profiles')
        .select('referral_code')
        .eq('id', userId)
        .single();
    return data['referral_code'] as String? ?? '';
  }

  Future<bool> applyReferralCode(String code, String newUserId) async {
    // Find profile with matching referral_code
    final referrer = await _client
        .from('profiles')
        .select('id')
        .eq('referral_code', code.toUpperCase())
        .maybeSingle();

    if (referrer == null) return false;

    final referrerId = referrer['id'] as String;
    if (referrerId == newUserId) return false; // Can't refer yourself

    await _client.from('referrals').insert({
      'referrer_id': referrerId,
      'referred_id': newUserId,
    });

    await _client
        .from('profiles')
        .update({'referred_by': code.toUpperCase()})
        .eq('id', newUserId);

    return true;
  }

  Future<int> getReferralCount(String userId) async {
    final result = await _client
        .from('referrals')
        .select('id')
        .eq('referrer_id', userId);
    return (result as List).length;
  }

  Future<void> checkAndGrantBonus(String userId) async {
    await _client.rpc('grant_referral_bonus', params: {'referred_user_id': userId});
  }

  Future<int> getBonusScans(String userId) async {
    final data = await _client
        .from('profiles')
        .select('bonus_scans')
        .eq('id', userId)
        .maybeSingle();
    return (data?['bonus_scans'] as int?) ?? 0;
  }
}
