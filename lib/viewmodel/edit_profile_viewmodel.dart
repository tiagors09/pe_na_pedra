import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/controller/edit_profile_controller.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';

class EditProfileViewModel extends ChangeNotifier with FormValidator {
  final _controller = EditProfileController();

  final form = GlobalKey<FormState>(debugLabel: 'edit_profile_form');

  final formData = <String, dynamic>{
    'fullName': '',
    'phone': '',
    'birthDate': '',
    'address': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
  };

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Métodos de salvar campos
  void onFullNameSaved(String? value) => formData['fullName'] = value ?? '';
  void onPhoneSaved(String? value) => formData['phone'] = value ?? '';
  void onAddressSaved(String? value) => formData['address'] = value ?? '';
  void onEmailSaved(String? value) => saveEmail(formData, value);
  void onPasswordSaved(String? value) => savePassword(formData, value);
  void onConfirmPasswordSaved(String? value) =>
      saveConfirmPassword(formData, value);

  // Validações
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome completo';
    }
    if (value.trim().split(' ').length < 2) return 'Digite nome e sobrenome';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe seu telefone';
    final phoneRegex = RegExp(r'^\+?[\d\s\(\)\-]{8,}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Telefone inválido';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != null && value.isNotEmpty && value != passwordController.text) {
      return 'As senhas não coincidem';
    }
    validateConfirmPasswordField(value);
    return null;
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final String formattedDisplayDate =
          DateFormat('dd/MM/yyyy').format(picked);
      final String formattedSupabaseDate =
          DateFormat('yyyy-MM-dd').format(picked);

      birthDateController.text = formattedDisplayDate;
      formData['birthDate'] = formattedSupabaseDate;

      notifyListeners();
      log('Data de nascimento selecionada: $formattedSupabaseDate',
          name: 'EditProfileViewModel');
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> submit(
    BuildContext context,
    GlobalState globalState,
    EditProfileMode mode,
  ) async {
    await _controller.submit(context, globalState, mode, this);
  }
}
