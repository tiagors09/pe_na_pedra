import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/edit_profile_viewmodel.dart';

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
  late EditProfileViewModel _viewModel;
  late final EditProfileViewArguments args;

  @override
  void initState() {
    _viewModel = EditProfileViewModel();
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
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompletingProfile = args.mode == EditProfileMode.completeProfile;
    final globalState = GlobalStateProvider.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.055,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _viewModel.isLoading
                  ? null
                  : () => _viewModel.submit(
                        context,
                        globalState,
                        args.mode,
                      ),
              child: _viewModel.isLoading
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
            key: _viewModel.form,
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
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nome completo'),
                    initialValue: _viewModel.formData['fullName'],
                    onSaved: _viewModel.onFullNameSaved,
                    validator: _viewModel.validateName,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    keyboardType: TextInputType.phone,
                    initialValue: _viewModel.formData['phone'],
                    onSaved: _viewModel.onPhoneSaved,
                    validator: _viewModel.validatePhone,
                  ),
                ),
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
                        onPressed: () => _viewModel.selectBirthDate(context),
                      ),
                    ),
                    controller: _viewModel.birthDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    initialValue: _viewModel.formData['address'],
                    onSaved: _viewModel.onAddressSaved,
                  ),
                ),
                if (!isCompletingProfile) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      initialValue: _viewModel.formData['email'],
                      onSaved: _viewModel.onEmailSaved,
                      validator: _viewModel.validateEmailField,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(_viewModel.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: _viewModel.toggleObscurePassword,
                        ),
                      ),
                      controller: _viewModel.passwordController,
                      obscureText: _viewModel.obscurePassword,
                      onSaved: _viewModel.onPasswordSaved,
                      validator: (value) => value!.isNotEmpty
                          ? _viewModel.validatePasswordField(value)
                          : null,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 24),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewModel.obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _viewModel.toggleObscureConfirmPassword,
                        ),
                      ),
                      obscureText: _viewModel.obscureConfirmPassword,
                      onSaved: _viewModel.onConfirmPasswordSaved,
                      validator: (value) =>
                          _viewModel.passwordController.text.isNotEmpty
                              ? _viewModel.validateConfirmPassword(value)
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
