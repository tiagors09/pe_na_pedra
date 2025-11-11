import 'dart:developer';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {
  final SupabaseClient supabase = SupabaseService.instance.client;

  Future<bool> login({
    required String email,
    required String password,
    required GlobalState globalState,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      final session = response.session;

      if (user != null && session != null) {
        globalState.setUser(user, session);
        return true;
      } else {
        log('Falha no login: resposta inválida', name: 'LoginController');
        return false;
      }
    } catch (e, st) {
      log('Erro no login: $e', name: 'LoginController', stackTrace: st);
      return false;
    }
  }

  Future<bool> createAccount({
    required String email,
    required String password,
    required GlobalState globalState,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      final session = response.session;

      if (user != null && session != null) {
        globalState.setUser(user, session);
        return true;
      } else {
        log('Falha ao criar conta: resposta inválida', name: 'LoginController');
        return false;
      }
    } catch (e, st) {
      log('Erro ao criar conta: $e', name: 'LoginController', stackTrace: st);
      return false;
    }
  }
}
