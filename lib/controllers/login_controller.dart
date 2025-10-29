import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:pe_na_pedra/providers/global_state.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends ChangeNotifier with FormValidator {
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

  Future<void> submit(BuildContext context, GlobalState globalState) async {
    log(
      'Submit iniciado',
      name: 'LoginView',
    );

    validate();
    if (form.currentState?.validate() ?? false) {
      log(
        'Formulário válido: $formData',
        name: 'LoginView',
      );

      form.currentState!.save();

      bool success;

      if (showRegister) {
        log(
          'Tentando criar conta',
          name: 'LoginView',
          level: 800,
        );

        success = await createAccount(globalState);
      } else {
        log(
          'Tentando login',
          name: 'LoginView',
          level: 800,
        );

        success = await login(globalState);
      }
      if (success) {
        log(
          'Login/Registro bem-sucedido',
          name: 'LoginView',
          level: 800,
        );

        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(
            showRegister ? AppRoutes.editProfile : AppRoutes.home,
            arguments: showRegister
                ? EditProfileViewArguments(
                    userId: globalState.user?.id,
                    mode: EditProfileMode.completeProfile,
                  )
                : null,
          );
        }
      } else {
        log(
          'Login/Registro falhou: $errorMessage',
          name: 'LoginView',
          level: 900,
        );
      }
    } else {
      log(
        'Formulário inválido',
        name: 'LoginView',
        level: 900,
      );
    }
  }

  void validate() {
    log(
      'Validando formulário de login',
      name: 'LoginController',
    );

    final formState = form.currentState;

    if (formState != null && formState.validate()) {
      formState.save();
      log(
        'Form válido: $formData',
        name: 'LoginController',
      );
    } else {
      log(
        'Form inválido',
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

  String? checkConfirmPassword(String? value) {
    if (!showRegister) return null;
    if (value != passwordController.text) return 'As senhas não coincidem';
    validateConfirmPasswordField(value);
    return null;
  }

  void onEmailSaved(String? value) {
    saveEmail(formData, value);
  }

  void onPasswordSaved(String? value) {
    savePassword(formData, value);
  }

  void onConfirmPasswordSaved(String? value) {
    saveConfirmPassword(formData, value);
  }
}
