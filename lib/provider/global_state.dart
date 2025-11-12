import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pe_na_pedra/controller/profile_controller.dart';

class GlobalState extends ChangeNotifier {
  User? _user;
  Session? _session;
  Map<String, dynamic>? _profile;
  Timer? _refreshTimer;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  Map<String, dynamic>? get profile => _profile;

  /// Define usuário e sessão globais
  Future<void> setUser(User user, Session session) async {
    _user = user;
    _session = session;
    log(
      'Usuário definido: ${user.email}',
      name: 'GlobalState',
      level: 800,
    );
    _scheduleTokenRefresh();
    notifyListeners();

    // 🔥 Carrega automaticamente o perfil completo
    try {
      final profileController = ProfileController();
      final data = await profileController.fetchProfileData(user.id);
      _profile = {
        'id': user.id,
        'email': user.email,
        ...data,
      };
      log(
        'Perfil carregado e armazenado globalmente $profile',
        name: 'GlobalState',
      );
    } catch (e) {
      log('Erro ao carregar perfil global: $e',
          name: 'GlobalState', level: 900);
    }
    notifyListeners();
  }

  /// Atualiza manualmente o perfil global (caso editado)
  void setProfile(Map<String, dynamic> profileData) {
    _profile = profileData;
    notifyListeners();
  }

  /// Faz logout completo
  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _user = null;
    _session = null;
    _profile = null;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    log('Usuário deslogado', name: 'GlobalState', level: 800);
    notifyListeners();
  }

  /// Agenda a renovação automática do token
  void _scheduleTokenRefresh() {
    _refreshTimer?.cancel();

    if (_session?.expiresAt == null) return;

    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final expiresAt = _session!.expiresAt!;
    final secondsUntilExpiry = expiresAt - now;

    final refreshIn = Duration(seconds: secondsUntilExpiry - 60);
    if (refreshIn.isNegative) {
      log('Token já está próximo da expiração ou expirado',
          name: 'GlobalState', level: 900);
      return;
    }

    log('Agendando renovação do token em ${refreshIn.inSeconds} segundos',
        name: 'GlobalState', level: 800);
    _refreshTimer = Timer(refreshIn, _refreshSession);
  }

  /// Faz a renovação automática da sessão do Supabase
  Future<void> _refreshSession() async {
    log('Tentando renovar sessão...', name: 'GlobalState', level: 800);
    try {
      final response = await Supabase.instance.client.auth.refreshSession();
      if (response.session != null) {
        _session = response.session;
        _user = response.user;
        log('Sessão renovada com sucesso para ${_user?.email}',
            name: 'GlobalState', level: 800);
        notifyListeners();
        _scheduleTokenRefresh();
      } else {
        log('Não foi possível renovar a sessão, deslogando',
            name: 'GlobalState', level: 900);
        logout();
      }
    } catch (e, st) {
      log('Erro ao renovar sessão: $e',
          name: 'GlobalState', level: 1000, error: e, stackTrace: st);
      logout();
    }
  }
}
