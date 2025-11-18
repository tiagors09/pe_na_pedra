// lib/controllers/login_controller.dart
import 'dart:developer';
import 'package:pe_na_pedra/provider/global_state.dart';

class LoginController {
  Future<bool> login({
    required String email,
    required String password,
    required GlobalState globalState,
  }) async {
    try {
      await globalState.signIn(email, password);
      return true;
    } catch (e, st) {
      log('Erro no login: $e', stackTrace: st, name: 'LoginController');
      return false;
    }
  }

  Future<bool> createAccount({
    required String email,
    required String password,
    required GlobalState globalState,
  }) async {
    try {
      await globalState.signUp(email, password);
      return true;
    } catch (e, st) {
      log('Erro ao criar conta: $e', stackTrace: st, name: 'LoginController');
      return false;
    }
  }
}
