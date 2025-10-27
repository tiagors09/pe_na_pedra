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
                autovalidateMode: AutovalidateMode.disabled,
                key: _controller.form,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (ctx, _) => Column(
                    mainAxisSize: MainAxisSize.min,
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
                          validator: _controller.validateEmail,
                          onSaved: _controller.saveEmail,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Senha'),
                          obscureText: true,
                          validator: _controller.validatePassword,
                          onSaved: _controller.savePassword,
                        ),
                      ),
                      Visibility(
                        visible: _controller.showRegister,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Confirmar Senha',
                            ),
                            obscureText: true,
                            validator: _controller.validateConfirmPassword,
                            onSaved: _controller.saveConfirmPassword,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: ElevatedButton(
                          onPressed: _controller.validate,
                          child: Text(
                            _controller.showRegister ? 'Registrar' : 'Entrar',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: TextButton(
                          onPressed: _controller.toggleLoginCard,
                          child: Text(
                            _controller.showRegister
                                ? 'Já possui conta? Entre'
                                : 'Criar conta',
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
      ),
    );
  }
}
