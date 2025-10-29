import 'package:flutter/material.dart';
import 'package:pe_na_pedra/providers/global_state_provider.dart';
import 'package:pe_na_pedra/controllers/edit_profile_controller.dart';

enum EditProfileMode {
  completeProfile,
  editProfile,
}

class EditProfileViewArguments {
  final String? userId;
  final EditProfileMode mode;

  EditProfileViewArguments({
    this.userId,
    required this.mode,
  });
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late EditProfileController _controller;
  late final EditProfileViewArguments args;

  @override
  void initState() {
    _controller = EditProfileController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(
      context,
    )!
        .settings
        .arguments as EditProfileViewArguments;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompletingProfile = args.mode == EditProfileMode.completeProfile;
    final globalState = GlobalStateProvider.of(context);

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.055,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _controller.isLoading
                  ? null
                  : () => _controller.submit(
                        context,
                        globalState,
                        args.mode,
                      ),
              child: _controller.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Salvar'),
            ),
          ),
          appBar: AppBar(
            title: Text(
              isCompletingProfile ? 'Completar Perfil' : 'Editar Perfil',
            ),
          ),
          body: Form(
            key: _controller.form,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  isCompletingProfile
                      ? 'Finalize seu cadastro preenchendo as informações abaixo.'
                      : 'Atualize suas informações de perfil.',
                  style: const TextStyle(fontSize: 16),
                ),

                // Nome completo
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nome completo'),
                    initialValue: _controller.formData['fullName'],
                    onSaved: _controller.onFullNameSaved,
                    validator: _controller.validateName,
                  ),
                ),

                // Telefone
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    keyboardType: TextInputType.phone,
                    initialValue: _controller.formData['phone'],
                    onSaved: _controller.onPhoneSaved,
                    validator: _controller.validatePhone,
                  ),
                ),

                // Data de nascimento (Com Date Picker)
                Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento (DD/MM/AAAA)',
                      hintText: 'Ex: 01/01/2000',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _controller.selectBirthDate(context),
                      ),
                    ),
                    controller: _controller.birthDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                  ),
                ),

                // Endereço
                Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    initialValue: _controller.formData['address'],
                    onSaved: _controller.onAddressSaved,
                  ),
                ),

                if (!isCompletingProfile) ...[
                  // E-mail
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      initialValue: _controller.formData['email'],
                      onSaved: _controller.onEmailSaved,
                      validator: _controller.validateEmailField,
                    ),
                  ),

                  // Senha
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(_controller.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: _controller.toggleObscurePassword,
                        ),
                      ),
                      controller: _controller.passwordController,
                      obscureText: _controller.obscurePassword,
                      onSaved: _controller.onPasswordSaved,
                      validator: (value) => value!.isNotEmpty
                          ? _controller.validatePasswordField(value)
                          : null,
                    ),
                  ),

                  // Confirmar Senha
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 24),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _controller.obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _controller.toggleObscureConfirmPassword,
                        ),
                      ),
                      obscureText: _controller.obscureConfirmPassword,
                      onSaved: _controller.onConfirmPasswordSaved,
                      validator: (value) =>
                          _controller.passwordController.text.isNotEmpty
                              ? _controller.validateConfirmPassword(value)
                              : null,
                    ),
                  ),
                ],

                if (isCompletingProfile) const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
