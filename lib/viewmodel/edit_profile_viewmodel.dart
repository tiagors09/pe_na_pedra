import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/controller/edit_profile_controller.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';

class EditProfileViewModel extends ChangeNotifier with FormValidator {
  final _controller = EditProfileController();

  final form = GlobalKey<FormState>(debugLabel: 'edit_profile_form');

  /// Dados do formulário
  final formData = <String, dynamic>{
    'fullName': '',
    'phone': '',
    'birthDate': '',
    'address': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
  };

  final _isLoading = ValueNotifier(false);
  final _obscurePassword = ValueNotifier(true);
  final _obscureConfirmPassword = ValueNotifier(true);

  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<bool> get obscurePassword => _obscurePassword;
  ValueNotifier<bool> get obscureConfirmPassword => _obscureConfirmPassword;

  /// Apenas data precisa de controller
  final TextEditingController birthDateController = TextEditingController();

  // ---------------------------------------------------------
  // CARREGA DADOS INICIAIS DO PERFIL
  // ---------------------------------------------------------
  void loadInitialData(Map<String, dynamic>? profile, {required bool editing}) {
    if (profile == null) return;

    formData['fullName'] = profile['fullName'] ?? '';
    formData['phone'] = profile['phone'] ?? '';
    formData['birthDate'] = profile['birthDate'] ?? '';
    formData['address'] = profile['address'] ?? '';
    formData['email'] = profile['email'] ?? '';

    // exibe no campo de data
    if (profile['birthDate'] != null &&
        profile['birthDate'].toString().isNotEmpty) {
      try {
        final date = DateTime.parse(profile['birthDate']);
        birthDateController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (_) {}
    }

    notifyListeners();
  }

  // ---------------------------------------------------------
  //  VISIBILIDADE SENHA
  // ---------------------------------------------------------
  void toggleObscurePassword() {
    _obscurePassword.value = !_obscurePassword.value;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
    notifyListeners();
  }

  // ---------------------------------------------------------
  //  SALVAR CAMPOS
  // ---------------------------------------------------------
  void onFullNameSaved(String? value) =>
      formData['fullName'] = value?.trim() ?? '';

  void onPhoneSaved(String? value) => formData['phone'] = value?.trim() ?? '';

  void onAddressSaved(String? value) =>
      formData['address'] = value?.trim() ?? '';

  void onEmailSaved(String? value) => saveEmail(
        formData,
        value,
      );

  void onPasswordSaved(String? value) => savePassword(
        formData,
        value,
      );

  void onConfirmPasswordSaved(String? value) {
    formData['confirmPassword'] = value ?? '';
  }

  // ---------------------------------------------------------
  //  VALIDAÇÕES
  // ---------------------------------------------------------
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome completo';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Digite nome e sobrenome';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe seu telefone';

    final regex = RegExp(r'^\+?[\d\s\(\)\-]{8,}$');
    if (!regex.hasMatch(value)) return 'Telefone inválido';

    return null;
  }

  @override
  String? validateConfirmPasswordField(String? value) {
    if (formData['password'].isNotEmpty && value != formData['password']) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // ---------------------------------------------------------
  //  SELETOR DE DATA
  // ---------------------------------------------------------
  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      formData['birthDate'] = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();

      log('Data selecionada: ${formData['birthDate']}',
          name: 'EditProfileViewModel');
    }
  }

  // ---------------------------------------------------------
  //  LOADING
  // ---------------------------------------------------------
  void setLoading(bool value) {
    _isLoading.value = value;
    notifyListeners();
  }

  // ---------------------------------------------------------
  //  SUBMIT
  // ---------------------------------------------------------
  Future<void> submit(
    BuildContext context,
    GlobalState globalState,
    EditProfileMode mode,
  ) async {
    await _controller.submit(context, globalState, mode, this);
  }

  @override
  void dispose() {
    birthDateController.dispose();
    super.dispose();
  }
}
