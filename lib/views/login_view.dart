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
    final globalState = GlobalStateProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5D204),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _vm.form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _vm.isLoading
                      ? [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 12),
                          const Text('Aguarde...'),
                        ]
                      : [
                          if (_vm.errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _vm.errorMessage,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'E-mail'),
                            validator: _vm.validateEmailField,
                            onSaved: _vm.onEmailSaved,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _vm.passwordController,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _vm.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: _vm.toggleObscurePassword,
                              ),
                            ),
                            obscureText: _vm.obscurePassword,
                            validator: _vm.validatePasswordField,
                            onSaved: _vm.onPasswordSaved,
                          ),
                          if (_vm.showRegister) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirmar Senha',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _vm.obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: _vm.toggleObscureConfirmPassword,
                                ),
                              ),
                              obscureText: _vm.obscureConfirmPassword,
                              validator: _vm.checkConfirmPassword,
                              onSaved: _vm.onConfirmPasswordSaved,
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _vm.submit(context, globalState),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _vm.showRegister ? 'Registrar' : 'Entrar',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: _vm.toggleRegister,
                              child: Text(
                                _vm.showRegister
                                    ? 'Já possui conta? Entrar'
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
    );
  }
}
