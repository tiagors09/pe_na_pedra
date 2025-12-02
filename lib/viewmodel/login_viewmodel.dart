import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/edit_profile_view_arguments.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/controller/login_controller.dart';

class LoginViewModel with FormValidator {
  final form = GlobalKey<FormState>();
  final _controller = LoginController();

  final passwordController = TextEditingController();

  final email = ValueNotifier<String>('');
  final password = ValueNotifier<String>('');
  final confirmPassword = ValueNotifier<String>('');

  final isLoading = ValueNotifier<bool>(false);
  final showRegister = ValueNotifier<bool>(false);
  final obscurePassword = ValueNotifier<bool>(true);
  final obscureConfirmPassword = ValueNotifier<bool>(true);
  final errorMessage = ValueNotifier<String>('');

  void toggleRegister() {
    showRegister.value = !showRegister.value;
    passwordController.clear();
  }

  void toggleObscurePassword() =>
      obscurePassword.value = !obscurePassword.value;

  void toggleObscureConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  void onEmailSaved(String? v) => email.value = v ?? '';
  void onPasswordSaved(String? v) => password.value = v ?? '';
  void onConfirmPasswordSaved(String? v) => confirmPassword.value = v ?? '';

  String? validateConfirmPassword(String? value) {
    if (!showRegister.value) return null;
    if (value != passwordController.text) return "As senhas não coincidem";
    return validateConfirmPasswordField(value);
  }

  Future<void> submit(BuildContext context, GlobalState global) async {
    if (!(form.currentState?.validate() ?? false)) return;

    form.currentState!.save();
    isLoading.value = true;
    errorMessage.value = '';

    bool ok;

    if (showRegister.value) {
      ok = await _controller.createAccount(
        email: email.value,
        password: password.value,
        globalState: global,
      );
    } else {
      ok = await _controller.login(
        email: email.value,
        password: password.value,
        globalState: global,
      );
    }

    isLoading.value = false;

    if (ok && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        showRegister.value ? AppRoutes.editProfile : AppRoutes.home,
        (_) => false,
        arguments: showRegister.value
            ? EditProfileViewArguments(
                userId: global.userId,
                mode: EditProfileMode.completeProfile,
              )
            : null,
      );
    } else {
      errorMessage.value = "Falha na autenticação";
    }
  }

  void dispose() {
    passwordController.dispose();
  }
}
