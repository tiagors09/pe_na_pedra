import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controllers/profile_view_controller.dart';
import 'package:pe_na_pedra/providers/global_state_provider.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  late ProfileViewController _controller;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final globalState = GlobalStateProvider.of(context);

    if (globalState.isLoggedIn && globalState.user != null && !_isInitialized) {
      final userId = globalState.user!.id;
      final userEmail = globalState.user!.email;

      _controller.initializeProfile(
        userId,
        userEmail!,
      );

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final globalState = GlobalStateProvider.of(context);

    return Center(
      child: globalState.isLoggedIn
          ? ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
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
          const SizedBox(height: 10),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              controller.invalidateCache();
              controller.fetchProfileData(
                globalState.user!.id,
              );
            },
            child: const Text(
              'Tentar Novamente',
            ),
          ),
        ],
      );
    }

    final fullName = data['fullName'] ?? '';
    final phone = data['phone'] ?? '';
    final address = data['address'] ?? '';
    final birthDate = controller.formatBirthDate(data['birthDate']);
    final email = data['email'] ?? '';

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
                  Icons.person,
                  'Nome Completo',
                  fullName,
                ),
                _buildDataItem(
                  context,
                  Icons.email,
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
                  Icons.calendar_today,
                  'Nascimento',
                  birthDate,
                ),
                _buildDataItem(
                  context,
                  Icons.home,
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
              onPressed: () async {
                await Navigator.of(context).pushNamed(
                  AppRoutes.editProfile,
                  arguments: EditProfileViewArguments(
                    mode: EditProfileMode.editProfile,
                  ),
                );
                controller.invalidateCache();
                controller.fetchProfileData(globalState.user!.id);
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
                size: 18,
              ),
              const SizedBox(width: 8),
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
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              AppRoutes.login,
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
