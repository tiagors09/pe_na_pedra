mixin FormValidator {
  String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) return 'O e-mail é obrigatório';

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) return 'E-mail inválido';

    return null;
  }

  String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) return 'A senha é obrigatória';
    if (value.length < 6) return 'A senha deve ter ao menos 6 caracteres';

    return null;
  }

  String? validateConfirmPasswordField(String? value) {
    if (value == null || value.isEmpty) return 'Confirme a senha';

    return null;
  }

  void saveEmail(
    Map<String, dynamic> formData,
    String? value,
  ) {
    formData['email'] = value ?? '';
  }

  void savePassword(
    Map<String, dynamic> formData,
    String? value,
  ) {
    formData['password'] = value ?? '';
  }

  void saveConfirmPassword(
    Map<String, dynamic> formData,
    String? value,
  ) {
    formData['confirmPassword'] = value ?? '';
  }
}
