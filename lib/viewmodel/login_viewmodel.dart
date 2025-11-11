import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/controller/login_controller.dart';

class LoginViewModel extends ChangeNotifier with FormValidator {
  final form = GlobalKey<FormState>();
  final _controller = LoginController();
  final passwordController = TextEditingController();

  final formData = {'email': '', 'password': '', 'confirmPassword': ''};

  bool isLoading = false;
  bool showRegister = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String errorMessage = '';

  void toggleRegister() {
    showRegister = !showRegister;
    notifyListeners();
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  void onEmailSaved(String? v) => saveEmail(formData, v);
  void onPasswordSaved(String? v) => savePassword(formData, v);
  void onConfirmPasswordSaved(String? v) => saveConfirmPassword(formData, v);

  String? checkConfirmPassword(String? value) {
    if (!showRegister) return null;
    if (value != passwordController.text) return 'As senhas não coincidem';
    return validateConfirmPasswordField(value);
  }

  Future<void> submit(BuildContext context, GlobalState globalState) async {
    if (!(form.currentState?.validate() ?? false)) return;

    form.currentState!.save();
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    bool success;
    if (showRegister) {
      success = await _controller.createAccount(
        email: formData['email']!,
        password: formData['password']!,
        globalState: globalState,
      );
    } else {
      success = await _controller.login(
        email: formData['email']!,
        password: formData['password']!,
        globalState: globalState,
      );
    }

    isLoading = false;
    notifyListeners();

    if (success && context.mounted) {
      Navigator.of(context).pushReplacementNamed(
        showRegister ? AppRoutes.editProfile : AppRoutes.home,
        arguments: showRegister
            ? EditProfileViewArguments(
                userId: globalState.user?.id,
                mode: EditProfileMode.completeProfile,
              )
            : null,
      );
    } else if (!success) {
      errorMessage = 'Falha na autenticação';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
