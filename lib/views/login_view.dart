import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = LoginViewModel();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final global = GlobalStateProvider.of(
      context,
    );

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5D204,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _vm.form,
                child: SingleChildScrollView(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _vm.isLoading,
                    builder: (_, loading, __) {
                      if (loading) {
                        return const Column(
                          spacing: 12,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              "Aguarde...",
                            ),
                          ],
                        );
                      }

                      return Column(
                        spacing: 16,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: _vm.errorMessage,
                            builder: (_, msg, __) => msg.isEmpty
                                ? const SizedBox()
                                : Text(
                                    msg,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                            ),
                            validator: _vm.validateEmailField,
                            onSaved: _vm.onEmailSaved,
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _vm.obscurePassword,
                            builder: (_, obscure, __) => TextFormField(
                              controller: _vm.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: _vm.toggleObscurePassword,
                                ),
                              ),
                              obscureText: obscure,
                              validator: _vm.validatePasswordField,
                              onSaved: _vm.onPasswordSaved,
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _vm.showRegister,
                            builder: (_, register, __) {
                              if (!register) return const SizedBox();

                              return Column(
                                spacing: 16,
                                children: [
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _vm.obscureConfirmPassword,
                                    builder: (_, obscure, __) => TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Confirmar Senha',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed:
                                              _vm.toggleObscureConfirmPassword,
                                        ),
                                      ),
                                      obscureText: obscure,
                                      validator: _vm.validateConfirmPassword,
                                      onSaved: _vm.onConfirmPasswordSaved,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 24,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _vm.submit(context, global),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _vm.showRegister,
                                  builder: (_, register, __) =>
                                      Text(register ? "Registrar" : "Entrar"),
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _vm.showRegister,
                            builder: (_, register, __) => TextButton(
                              onPressed: _vm.toggleRegister,
                              child: Text(
                                register
                                    ? "Já possui conta? Entrar"
                                    : "Criar conta",
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
      ),
    );
  }
}
