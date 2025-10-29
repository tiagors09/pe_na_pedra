import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controllers/profile_view_controller.dart';
import 'package:pe_na_pedra/providers/global_state_provider.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileViewController _controller;

  @override
  void initState() {
    _controller = ProfileViewController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalState = GlobalStateProvider.of(context);

    log(
      'Construindo ProfileView - isLoggedIn: ${globalState.isLoggedIn}',
      name: 'ProfileView',
    );

    return Center(
      child: globalState.isLoggedIn
          ? ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                if (_controller.isLoading) {
                  return const CircularProgressIndicator();
                }
                return _buildProfileDataColumn(
                  context,
                  globalState,
                  _controller,
                );
              },
            )
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildProfileDataColumn(
      BuildContext context, globalState, ProfileViewController controller) {
    final data = controller.profileData;
    final errorMessage = controller.errorMessage;

    if (errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.amber,
            size: 40,
          ),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.fetchProfileData(
              globalState.user!.id,
            ),
            child: const Text(
              'Tentar Novamente',
            ),
          ),
        ],
      );
    }

    final fullName = data?['fullName'] ?? 'Não informado';
    final phone = data?['phone'] ?? 'Não informado';
    final address = data?['address'] ?? 'Não informado';
    final birthDate = controller.formatBirthDate(data?['birthDate']);
    final email = data?['email'] ?? 'Não informado';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bem-vindo, ${fullName.split(' ').first}!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Container(
            padding: const EdgeInsets.all(
              16,
            ),
            width: MediaQuery.of(context).size.width * (1 / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDataItem(
                  context,
                  Icons.abc,
                  'Nome Completo',
                  fullName,
                ),
                _buildDataItem(
                  context,
                  Icons.date_range,
                  'Email',
                  email,
                ),
                _buildDataItem(
                  context,
                  Icons.phone,
                  'Telefone',
                  phone,
                ),
                _buildDataItem(
                  context,
                  Icons.date_range_outlined,
                  'Nascimento',
                  birthDate,
                ),
                _buildDataItem(
                  context,
                  Icons.abc,
                  'Endereço',
                  address,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 4,
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/edit-profile',
                  arguments: EditProfileViewArguments(
                    mode: EditProfileMode.editProfile,
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text(
                'Editar Perfil',
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              globalState.logout();
              log(
                'Usuário deslogado',
                name: 'ProfileView',
                level: 800,
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
            label: const Text(
              'Sair da Conta',
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para exibir um item de dado
  Widget _buildDataItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            value,
          ),
        ],
      ),
    );
  }

  // === Prompt de Login (usuário deslogado) ===
  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Você precisa fazer login ou se cadastrar para acessar o perfil.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/login',
            );
          },
          child: const Text(
            'Fazer Login / Cadastrar',
          ),
        ),
      ],
    );
  }
}
