import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:pe_na_pedra/providers/global_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends ChangeNotifier {
  final form = GlobalKey<FormState>(debugLabel: 'login_form');
  final formData = <String, dynamic>{
    'email': '',
    'password': '',
    'confirmPassword': '',
  };
  bool showRegister = false;
  bool isLoading = false;
  String errorMessage = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  final TextEditingController passwordController = TextEditingController();
  void toogleObscurePassword() {
    log(
      'Toggling obscure password',
      name: 'LoginController',
    );
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toogleObscureConfirmPassword() {
    log(
      'Toggling obscure password',
      name: 'LoginController',
    );
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  final SupabaseClient supabase = Supabase.instance.client;
  void toggleLoginCard() {
    showRegister = !showRegister;
    notifyListeners();
  }

  void validate() {
    log('Validating login form', name: 'LoginController');
    final formState = form.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      log(
        'Form is valid: $formData',
        name: 'LoginController',
      );
    } else {
      log(
        'Form is invalid',
        name: 'LoginController',
      );
    }
  }

  Future<bool> login(GlobalState globalState) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    log(
      'Iniciando login para ${formData['email']}',
      name: 'LoginController',
    );
    try {
      final response = await supabase.auth.signInWithPassword(
        email: formData['email'],
        password: formData['password'],
      );
      final user = response.user;
      final session = response.session;
      if (user != null && session != null) {
        log(
          'Login bem-sucedido: ${user.email}',
          name: 'LoginController',
          level: 800,
        );

        // Integra com GlobalState para armazenar user + session e agendar renovação
        globalState.setUser(
          user,
          session,
        );

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = 'Login falhou';
        log(
          'Login falhou: resposta sem usuário ou sessão',
          name: 'LoginController',
          level: 900,
        );
      }
    } catch (e, st) {
      log(
        'Erro ao fazer login: $e',
        name: 'LoginController',
        level: 1000,
        stackTrace: st,
      );
      errorMessage = 'Erro ao fazer login';
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> createAccount(GlobalState globalState) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    log('Iniciando criação de conta para ${formData['email']}',
        name: 'LoginController');
    try {
      final response = await supabase.auth.signUp(
        email: formData['email'],
        password: formData['password'],
      );
      final user = response.user;
      final session = response.session;
      if (user != null && session != null) {
        log(
          'Conta criada com sucesso: ${user.email}',
          name: 'LoginController',
          level: 800,
        );

        // Integra com GlobalState para armazenar user + session e agendar renovação
        globalState.setUser(
          user,
          session,
        );

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = 'Falha ao criar conta';
        log(
          'Falha ao criar conta: resposta sem usuário ou sessão',
          name: 'LoginController',
          level: 900,
        );
      }
    } catch (e, st) {
      log(
        'Erro ao criar conta: $e',
        name: 'LoginController',
        level: 1000,
        stackTrace: st,
      );
      errorMessage = 'Erro ao criar conta';
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'O e-mail é obrigatório';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'A senha é obrigatória';
    if (value.length < 6) return 'A senha deve ter ao menos 6 caracteres';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (!showRegister) return null;
    if (value == null || value.isEmpty) return 'Confirme a senha';
    if (value != passwordController.text) return 'As senhas não coincidem';
    return null;
  }

  void saveEmail(String? value) {
    formData['email'] = value ?? '';
  }

  void savePassword(String? value) {
    formData['password'] = value ?? '';
  }

  void saveConfirmPassword(String? value) {
    formData['confirmPassword'] = value ?? '';
  }
}
