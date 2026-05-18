import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.isLocalSession,
  });

  final String id;
  final String email;
  final bool isLocalSession;
}

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<AppUser?> currentUser();

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
  });

  Future<void> resetPassword(String email);

  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.map(
      (event) => _mapSupabaseUser(event.session?.user),
    );
  }

  @override
  Future<AppUser?> currentUser() async {
    return _mapSupabaseUser(_client.auth.currentUser);
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(email: email, password: password);
    await _signInWithRetry(email: email, password: password);
  }

  @override
  Future<void> resetPassword(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> signOut() {
    return _client.auth.signOut();
  }

  AppUser? _mapSupabaseUser(User? user) {
    if (user == null || user.email == null) {
      return null;
    }

    return AppUser(
      id: user.id,
      email: user.email!,
      isLocalSession: false,
    );
  }

  Future<void> _signInWithRetry({
    required String email,
    required String password,
  }) async {
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        await _client.auth.signInWithPassword(email: email, password: password);
        return;
      } on AuthException {
        if (attempt == 2) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 350));
      }
    }
  }
}

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._storage);

  static const _sessionKey = 'local_auth_session_v1';

  final FlutterSecureStorage _storage;
  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  AppUser? _cachedUser;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield await currentUser();
    yield* _controller.stream;
  }

  @override
  Future<AppUser?> currentUser() async {
    if (_cachedUser != null) {
      return _cachedUser;
    }

    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final data = jsonDecode(raw) as Map<String, dynamic>;
    _cachedUser = AppUser(
      id: data['id'] as String,
      email: data['email'] as String,
      isLocalSession: true,
    );
    return _cachedUser;
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _saveLocalUser(email);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _saveLocalUser(email);
  }

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<void> signOut() async {
    _cachedUser = null;
    await _storage.delete(key: _sessionKey);
    _controller.add(null);
  }

  Future<void> _saveLocalUser(String email) async {
    final user = AppUser(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      email: email,
      isLocalSession: true,
    );
    _cachedUser = user;
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode(<String, String>{
        'id': user.id,
        'email': user.email,
      }),
    );
    _controller.add(user);
  }

  void dispose() {
    _controller.close();
  }
}
