import 'dart:developer';
import 'package:flutter/widgets.dart';

class LoginController extends ChangeNotifier {
  final form = GlobalKey<FormState>(debugLabel: 'login_form');

  final formData = <String, dynamic>{
    'email': '',
    'password': '',
    'confirmPassword': '',
  };

  bool showRegister = false;

  void toggleLoginCard() {
    showRegister = !showRegister;
    notifyListeners();
  }

  void validate() {
    log('Validating login form', name: 'LoginController');

    final formState = form.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      log('Form is valid: $formData', name: 'LoginController');
    } else {
      log('Form is invalid', name: 'LoginController');
    }
  }

  void createAccount() {
    log('Create account logic here: $formData', name: 'LoginController');
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
    if (value != formData['password']) return 'As senhas não coincidem';
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
