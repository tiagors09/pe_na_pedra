import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalState extends ChangeNotifier {
  User? _user;
  Session? _session;
  Timer? _refreshTimer;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void setUser(User user, Session session) {
    _user = user;
    _session = session;
    log(
      'Usuário definido: ${user.email}',
      name: 'GlobalState',
      level: 800,
    );
    _scheduleTokenRefresh();
    notifyListeners();
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    _user = null;
    _session = null;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    log(
      'Usuário deslogado',
      name: 'GlobalState',
      level: 800,
    );
    notifyListeners();
  }

  void _scheduleTokenRefresh() {
    _refreshTimer?.cancel();

    if (_session?.expiresAt == null) return;

    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final expiresAt = _session!.expiresAt!;
    final secondsUntilExpiry = expiresAt - now;

    final refreshIn = Duration(seconds: secondsUntilExpiry - 60);
    if (refreshIn.isNegative) {
      log(
        'Token já está próximo da expiração ou expirado',
        name: 'GlobalState',
        level: 900,
      );
      return;
    }

    log(
      'Agendando renovação do token em ${refreshIn.inSeconds} segundos',
      name: 'GlobalState',
      level: 800,
    );
    _refreshTimer = Timer(
      refreshIn,
      _refreshSession,
    );
  }

  Future<void> _refreshSession() async {
    log('Tentando renovar sessão...', name: 'GlobalState', level: 800);
    try {
      final response = await Supabase.instance.client.auth.refreshSession();
      if (response.session != null) {
        _session = response.session;
        _user = response.user;
        log(
          'Sessão renovada com sucesso para ${_user?.email}',
          name: 'GlobalState',
          level: 800,
        );
        notifyListeners();
        _scheduleTokenRefresh();
      } else {
        log(
          'Não foi possível renovar a sessão, deslogando',
          name: 'GlobalState',
          level: 900,
        );
        logout();
      }
    } catch (e, st) {
      log(
        'Erro ao renovar sessão: $e',
        name: 'GlobalState',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      logout();
    }
  }
}
