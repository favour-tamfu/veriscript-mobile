import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../domain/auth_failure.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(supabaseClientProvider)),
);

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (error) {
      throw _mapAuthException(error);
    } on SocketException {
      throw const NetworkError();
    } catch (_) {
      throw const Unknown();
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{'display_name': displayName},
      );

      final userId = response.user?.id;
      if (userId != null) {
        await _client.from('profiles').upsert(<String, dynamic>{
          'id': userId,
          'email': email,
          'display_name': displayName,
        });
      }
    } on AuthException catch (error) {
      throw _mapAuthException(error);
    } on SocketException {
      throw const NetworkError();
    } catch (_) {
      throw const Unknown();
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on SocketException {
      throw const NetworkError();
    } catch (_) {
      throw const Unknown();
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (error) {
      throw _mapAuthException(error);
    } on SocketException {
      throw const NetworkError();
    } catch (_) {
      throw const Unknown();
    }
  }

  AuthFailure _mapAuthException(AuthException error) {
    final message = error.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return const InvalidCredentials();
    }

    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return const EmailAlreadyInUse();
    }

    if (message.contains('password should be at least') ||
        message.contains('weak password')) {
      return const WeakPassword();
    }

    if (message.contains('network') || message.contains('connection')) {
      return const NetworkError();
    }

    return const Unknown();
  }
}
