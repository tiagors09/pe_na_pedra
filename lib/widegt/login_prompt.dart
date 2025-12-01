import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback? onLogin;

  const LoginPrompt({super.key, this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Você precisa fazer login para acessar o perfil.',
          ),
          ElevatedButton(
            onPressed: onLogin,
            child: const Text(
              'Fazer Login / Cadastrar',
            ),
          ),
        ],
      ),
    );
  }
}
