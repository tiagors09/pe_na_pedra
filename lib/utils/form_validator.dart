import 'package:pe_na_pedra/model/route_point.dart';
import 'package:pe_na_pedra/utils/enums.dart';

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

  String? validateNameField(String? value) {
    if (value == null || value.isEmpty) return 'O nome da trilha é obrigatório';
    if (value.length < 3) return 'O nome deve ter ao menos 3 caracteres';
    return null;
  }

  String? validateDifficultyField(Difficulty? value) {
    if (value == null) return 'Selecione a dificuldade';
    return null;
  }

  String? validateRoutePoints(List<RoutePoint>? points) {
    if (points == null || points.isEmpty) return 'É necessário gravar a rota';
    return null;
  }
}
