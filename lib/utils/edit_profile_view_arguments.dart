import 'package:pe_na_pedra/utils/enums.dart';

class EditProfileViewArguments {
  final String? userId;
  final EditProfileMode mode;

  EditProfileViewArguments({
    this.userId,
    required this.mode,
  });
}
