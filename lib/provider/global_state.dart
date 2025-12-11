import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/services/auth_cache_service.dart';
import 'package:pe_na_pedra/services/firebase_auth_service.dart';
import 'package:pe_na_pedra/services/firebase_rest_service.dart';
import 'package:pe_na_pedra/storage/secure_storage.dart';

class GlobalState extends ChangeNotifier {
  String? _idToken;
  String? _refreshToken;
  String? _userId;
  Map<String, dynamic>? _profile;
  Timer? _refreshTimer;

  String? get idToken => _idToken;
  String? get refreshToken => _refreshToken;
  String? get userId => _userId;
  Map<String, dynamic>? get profile => _profile;
  bool get isLoggedIn => _idToken != null && _userId != null;

  Future<void> restoreFromStorage() async {
    // 1. tenta carregar do secure storage (fonte principal)
    _idToken = await SecureStorage.instance.read('idToken');
    _refreshToken = await SecureStorage.instance.read('refreshToken');
    _userId = await SecureStorage.instance.read('userId');

    // 2. se não achar, tenta do SharedPreferences (fallback)
    if (_idToken == null || _refreshToken == null || _userId == null) {
      final session = await AuthCacheService.loadSession();
      _idToken = session["idToken"];
      _refreshToken = session["refreshToken"];
      _userId = session["userId"];

      // se achou no SharedPreferences, sincroniza de volta para o secure
      if (_idToken != null && _refreshToken != null && _userId != null) {
        await SecureStorage.instance.write('idToken', _idToken!);
        await SecureStorage.instance.write('refreshToken', _refreshToken!);
        await SecureStorage.instance.write('userId', _userId!);
      }
    }

    // 3. carrega perfil do cache normalmente
    _profile = await AuthCacheService.loadProfile();

    // 4. se tiver tudo, já notifica UI
    if (_idToken != null && _userId != null) {
      notifyListeners();

      // 5. executa refresh e sincroniza perfil
      unawaited(_refreshAuth());
      unawaited(loadProfile());
    }
  }

  // -------------------------------------------------------------
  // Sign In
  // -------------------------------------------------------------
  Future<void> signIn(String email, String password) async {
    final res = await FirebaseAuthService.instance
        .signIn(email: email, password: password);

    if (res['idToken'] == null) {
      throw Exception(res['error'] ?? 'Login failed');
    }

    await _handleAuthResponse(res);
    await loadProfile();

    // salva cache simples
    await AuthCacheService.saveSession(
      userId: _userId!,
      idToken: _idToken!,
      refreshToken: _refreshToken!,
    );

    notifyListeners();
  }

  // -------------------------------------------------------------
  // Sign Up
  // -------------------------------------------------------------
  Future<void> signUp(String email, String password) async {
    final res = await FirebaseAuthService.instance
        .signUp(email: email, password: password);

    if (res['idToken'] == null) {
      throw Exception(res['error'] ?? 'Signup failed');
    }

    await _handleAuthResponse(res);

    // salva também no cache
    await AuthCacheService.saveSession(
      userId: _userId!,
      idToken: _idToken!,
      refreshToken: _refreshToken!,
    );

    notifyListeners();
  }

  // -------------------------------------------------------------
  // Trata tokens + agendamento
  // -------------------------------------------------------------
  Future<void> _handleAuthResponse(Map<String, dynamic> res) async {
    _idToken = res['idToken'];
    _refreshToken = res['refreshToken'];
    _userId = res['localId'] ?? res['userId'] ?? res['uid'];

    // 1. salva primeiro no secure storage
    await SecureStorage.instance.write('idToken', _idToken!);
    await SecureStorage.instance.write('refreshToken', _refreshToken!);
    await SecureStorage.instance.write('userId', _userId!);

    // 2. sincroniza automaticamente para SharedPreferences
    await AuthCacheService.saveSession(
      userId: _userId!,
      idToken: _idToken!,
      refreshToken: _refreshToken!,
    );

    // 3. agenda refresh automático
    final expiresIn = int.tryParse(res['expiresIn']?.toString() ?? '') ?? 3600;
    _scheduleRefresh(Duration(seconds: expiresIn));
  }

  void _scheduleRefresh(Duration expiresIn) {
    _refreshTimer?.cancel();

    final refreshIn = expiresIn - const Duration(seconds: 30);
    _refreshTimer = Timer(refreshIn, _refreshAuth);
  }

  // -------------------------------------------------------------
  // REFRESH automático (Firebase Secure Token API)
  // -------------------------------------------------------------
  Future<void> _refreshAuth() async {
    if (_refreshToken == null) {
      logout();
      return;
    }

    try {
      final res = await FirebaseAuthService.instance.refresh(_refreshToken!);

      if (res['id_token'] != null) {
        _idToken = res['id_token'];
        _refreshToken = res['refresh_token'];

        // 1. atualiza secure storage (fonte principal)
        await SecureStorage.instance.write('idToken', _idToken!);
        await SecureStorage.instance.write('refreshToken', _refreshToken!);

        // 2. sincroniza também com SharedPreferences
        await AuthCacheService.saveSession(
          userId: _userId!,
          idToken: _idToken!,
          refreshToken: _refreshToken!,
        );

        final expiresIn =
            int.tryParse(res['expires_in']?.toString() ?? '') ?? 3600;

        _scheduleRefresh(Duration(seconds: expiresIn));
        notifyListeners();
      } else {
        logout();
      }
    } catch (e) {
      logout();
    }
  }

  // -------------------------------------------------------------
  // Load Profile
  // -------------------------------------------------------------
  Future<void> loadProfile() async {
    if (_userId == null || _idToken == null) return;

    try {
      final data = await FirebaseRestService.instance.get(
        'hikkers/$_userId',
        auth: _idToken,
      );

      if (data != null) {
        _profile = Map<String, dynamic>.from(data);
      }
    } catch (_) {}
  }

  // -------------------------------------------------------------
  // Logout
  // -------------------------------------------------------------
  Future<void> logout() async {
    _refreshTimer?.cancel();

    _idToken = null;
    _refreshToken = null;
    _userId = null;
    _profile = null;

    await SecureStorage.instance.delete('idToken');
    await SecureStorage.instance.delete('refreshToken');
    await SecureStorage.instance.delete('userId');

    await AuthCacheService.clear();

    notifyListeners();
  }

  Future<void> setProfile(Map<String, dynamic> profile) async {
    if (_userId == null || _idToken == null) return;
    await FirebaseRestService.instance.put(
      'hikkers/$_userId',
      profile,
      auth: _idToken,
    );
    _profile = profile;
    notifyListeners();
  }
}
