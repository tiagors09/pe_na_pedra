import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF5D204),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * (1 / 3),
          ),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _controller.form,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 👈 faz o "HUG"
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                        top: 8,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: ElevatedButton(
                        onPressed: _controller.validate,
                        child: const Text(
                          'Login',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: TextButton(
                        onPressed: _controller.createAccount,
                        child: const Text(
                          'Criar conta',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
