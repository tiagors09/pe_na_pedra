import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pe_na_pedra/providers/global_state.dart';

class EditProfileController extends ChangeNotifier with FormValidator {
  final form = GlobalKey<FormState>(
    debugLabel: 'edit_profile_form',
  );

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

  final SupabaseClient supabase = Supabase.instance.client;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void onFullNameSaved(String? value) => formData['fullName'] = value ?? '';

  void onPhoneSaved(String? value) => formData['phone'] = value ?? '';

  void onAddressSaved(String? value) => formData['address'] = value ?? '';

  void onEmailSaved(String? value) {
    saveEmail(formData, value);
  }

  void onPasswordSaved(String? value) {
    savePassword(formData, value);
  }

  void onConfirmPasswordSaved(String? value) {
    saveConfirmPassword(formData, value);
  }

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
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu telefone';
    }
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
      log(
        'Data de nascimento selecionada: $formattedSupabaseDate',
        name: 'EditProfileController',
      );
    }
  }

  Future<void> submit(
    BuildContext? context,
    GlobalState globalState,
    EditProfileMode mode,
  ) async {
    if (!(form.currentState?.validate() ?? false)) return;
    form.currentState!.save();

    try {
      isLoading = true;
      notifyListeners();

      final userId = globalState.user?.id;
      if (userId == null) return;

      final values = {
        'id': userId,
        'full_name': formData['fullName'],
        'phone': formData['phone'],
        'birth_date': formData['birthDate'],
        'address': formData['address'],
      };

      switch (mode) {
        case EditProfileMode.completeProfile:
          await supabase.from('profiles').insert(
                values,
              );
          break;
        case EditProfileMode.editProfile:
          await supabase
              .from('profiles')
              .update(
                values,
              )
              .eq(
                'id',
                userId,
              );

          if (formData['password'].isNotEmpty) {
            await supabase.auth.updateUser(
              UserAttributes(
                password: formData['password'],
              ),
            );
          }
          break;
      }

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Perfil atualizado com sucesso!',
            ),
          ),
        );

        Navigator.of(
          context,
        ).pushReplacementNamed(
          AppRoutes.home,
        );
      }

      log('Perfil atualizado com sucesso', name: 'EditProfileController');
    } catch (e, st) {
      if (context != null && context.mounted) {
        log(
          'Erro ao salvar perfil: Tipo de erro: ${e.runtimeType}, Mensagem: $e',
          name: 'EditProfileController',
          level: 1000,
          stackTrace: st,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erro ao salvar perfil. Verifique suas permissões: ${e.toString()}'),
          ),
        );
      }
      log(
        'Erro ao salvar perfil: $e',
        name: 'EditProfileController',
        stackTrace: st,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
