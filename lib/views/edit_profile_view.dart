import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/edit_profile_view_arguments.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/viewmodel/edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late EditProfileViewModel _viewModel;
  late EditProfileViewArguments args;
  bool _initialized = false;

  @override
  void initState() {
    _viewModel = EditProfileViewModel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    args =
        ModalRoute.of(context)!.settings.arguments as EditProfileViewArguments;

    final globalState = GlobalStateProvider.of(context);

    // 🔥 Carrega profile no formData antes da primeira renderização
    _viewModel.loadInitialData(
      globalState.profile,
      editing: args.mode == EditProfileMode.editProfile,
    );
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

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.055,
          margin: const EdgeInsets.all(16),
          child: ValueListenableBuilder(
            valueListenable: _viewModel.isLoading,
            builder: (context, isLoading, _) {
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => _viewModel.submit(
                          context,
                          globalState,
                          args.mode,
                        ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Salvar'),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          isCompletingProfile ? 'Completar Perfil' : 'Editar Perfil',
        ),
      ),
      body: Form(
        key: _viewModel.form,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              isCompletingProfile
                  ? 'Finalize seu cadastro preenchendo as informações abaixo.'
                  : 'Atualize suas informações de perfil.',
              style: const TextStyle(fontSize: 16),
            ),

            // -----------------------------
            // Nome
            // -----------------------------
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Nome completo'),
                initialValue: _viewModel.formData['fullName'],
                onSaved: _viewModel.onFullNameSaved,
                validator: _viewModel.validateName,
              ),
            ),

            // -----------------------------
            // Telefone
            // -----------------------------
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

            // -----------------------------
            // Data de nascimento
            // -----------------------------
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento (DD/MM/AAAA)',
                  hintText: 'Ex: 01/01/2000',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _viewModel.selectBirthDate(context),
                  ),
                ),
                readOnly: true,
                controller: _viewModel.birthDateController,
              ),
            ),

            // -----------------------------
            // Endereço
            // -----------------------------
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Endereço'),
                initialValue: _viewModel.formData['address'],
                onSaved: _viewModel.onAddressSaved,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
