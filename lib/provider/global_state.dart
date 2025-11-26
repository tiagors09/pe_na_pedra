// lib/provider/global_state.dart
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
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
    _idToken = await SecureStorage.instance.read('idToken');
    _refreshToken = await SecureStorage.instance.read('refreshToken');
    _userId = await SecureStorage.instance.read('userId');
    if (_idToken != null && _userId != null) {
      _scheduleRefreshFromStored();
      await loadProfile(); // attempt load profile
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    final res = await FirebaseAuthService.instance
        .signIn(email: email, password: password);
    if (res['idToken'] != null) {
      _handleAuthResponse(res);
      await loadProfile();
      notifyListeners();
    } else {
      throw Exception(res['error'] ?? 'Login failed');
    }
  }

  Future<void> signUp(String email, String password) async {
    final res = await FirebaseAuthService.instance
        .signUp(email: email, password: password);
    if (res['idToken'] != null) {
      _handleAuthResponse(res);
      // profile can be created later
      notifyListeners();
    } else {
      throw Exception(res['error'] ?? 'Signup failed');
    }
  }

  void _handleAuthResponse(Map<String, dynamic> res) async {
    _idToken = res['idToken'];
    _refreshToken = res['refreshToken'];
    _userId = res['localId'] ?? res['userId'] ?? res['uid'];
    // Save secure
    await SecureStorage.instance.write('idToken', _idToken!);
    if (_refreshToken != null) {
      await SecureStorage.instance.write(
        'refreshToken',
        _refreshToken!,
      );
    }
    if (_userId != null) await SecureStorage.instance.write('userId', _userId!);

    final expiresIn = int.tryParse(res['expiresIn']?.toString() ?? '') ?? 3600;

    _scheduleRefresh(
      Duration(seconds: expiresIn),
    );
  }

  void _scheduleRefresh(Duration expiresIn) {
    _refreshTimer?.cancel();
    // refresh 60s before expiry
    final refreshIn = expiresIn - const Duration(seconds: 60);
    _refreshTimer = Timer(refreshIn, _refreshAuth);
  }

  void _scheduleRefreshFromStored() {
    // default polling refresh every 50 minutes as we don't know exact expiry
    _refreshTimer?.cancel();
    _refreshTimer = Timer(const Duration(minutes: 50), _refreshAuth);
  }

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
        await SecureStorage.instance.write('idToken', _idToken!);
        if (_refreshToken != null) {
          await SecureStorage.instance.write(
            'refreshToken',
            _refreshToken!,
          );
        }
        // schedule again using expires_in
        final expiresIn =
            int.tryParse(res['expires_in']?.toString() ?? '') ?? 3600;
        _scheduleRefresh(Duration(seconds: expiresIn));
        notifyListeners();
      } else {
        logout();
      }
    } catch (e, st) {
      log('Error refreshing token: $e', stackTrace: st);
      logout();
    }
  }

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
    } catch (e) {
      // ignore
    }
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

  Future<void> logout() async {
    _idToken = null;
    _refreshToken = null;
    _userId = null;
    _profile = null;
    _refreshTimer?.cancel();
    await SecureStorage.instance.delete('idToken');
    await SecureStorage.instance.delete('refreshToken');
    await SecureStorage.instance.delete('userId');
    notifyListeners();
  }
}
