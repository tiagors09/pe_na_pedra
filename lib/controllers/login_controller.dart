import 'dart:developer';

import 'package:flutter/widgets.dart';

class LoginController {
  final form = GlobalKey<FormState>();
  final formData = <String, dynamic>{};

  void validate() {
    log(
      'Validating login form',
      name: 'LoginController',
    );

    final formState = form.currentState;
    if (formState != null && formState.validate()) {
      log(
        'Login form is valid',
        name: 'LoginController',
      );
      formState.save();
    }
  }

  void createAccount() {
    log(
      'Create account logic here',
      name: 'LoginController',
    );
  }
}
