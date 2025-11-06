import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controllers/login_controller.dart';
import 'package:pe_na_pedra/providers/global_state_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginController _controller;

  @override
  void initState() {
    _controller = LoginController();

    log(
      'LoginController iniciado',
      name: 'LoginView',
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final globalState = GlobalStateProvider.of(context);

    log(
      'Construindo LoginView',
      name: 'LoginView',
    );
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
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: _controller.form,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (ctx, _) {
                    log(
                      'ListenableBuilder rebuild',
                      name: 'LoginView',
                    );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _controller.isLoading
                          ? [
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: const CircularProgressIndicator(),
                                  ),
                                  const Text(
                                    'Aguarde...',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ]
                          : [
                              Visibility(
                                visible: _controller.errorMessage.isNotEmpty,
                                child: Text(
                                  _controller.errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                  top: 8,
                                ),
                                child: TextFormField(
                                  enabled: !_controller.isLoading,
                                  decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                  ),
                                  validator: _controller.validateEmailField,
                                  onSaved: _controller.onEmailSaved,
                                  onChanged: (v) => log(
                                    'Email alterado: $v',
                                    name: 'LoginView',
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: TextFormField(
                                  controller: _controller.passwordController,
                                  enabled: !_controller.isLoading,
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    suffixIcon: IconButton(
                                      onPressed:
                                          _controller.toogleObscurePassword,
                                      icon: Icon(
                                        _controller.obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  obscureText: _controller.obscurePassword,
                                  validator: _controller.validatePasswordField,
                                  onSaved: _controller.onPasswordSaved,
                                  onChanged: (v) => log(
                                    'Senha alterada',
                                    name: 'LoginView',
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _controller.showRegister,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: TextFormField(
                                    enabled: !_controller.isLoading,
                                    decoration: InputDecoration(
                                      labelText: 'Confirmar Senha',
                                      suffixIcon: IconButton(
                                        onPressed: _controller
                                            .toogleObscureConfirmPassword,
                                        icon: Icon(
                                          _controller.obscureConfirmPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                    obscureText:
                                        _controller.obscureConfirmPassword,
                                    validator: _controller
                                        .validateConfirmPasswordField,
                                    onSaved: _controller.onConfirmPasswordSaved,
                                    onChanged: (v) => log(
                                      'ConfirmSenha alterada',
                                      name: 'LoginView',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: ElevatedButton(
                                  onPressed: _controller.isLoading
                                      ? null
                                      : () => _controller.submit(
                                            context,
                                            globalState,
                                          ),
                                  child: Text(
                                    _controller.showRegister
                                        ? 'Registrar'
                                        : 'Entrar',
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 8,
                                ),
                                child: TextButton(
                                  onPressed: _controller.isLoading
                                      ? null
                                      : () {
                                          _controller.toggleLoginCard();
                                          log(
                                            'Toggle login/register: showRegister=${_controller.showRegister}',
                                            name: 'LoginView',
                                          );
                                        },
                                  child: Text(
                                    _controller.showRegister
                                        ? 'Já possui conta? Entre'
                                        : 'Criar conta',
                                  ),
                                ),
                              ),
                            ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    log('LoginController descartado', name: 'LoginView');
    super.dispose();
  }
}
