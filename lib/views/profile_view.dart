import 'package:flutter/material.dart';
import 'package:pe_na_pedra/viewmodel/profile_viewmodel.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  late ProfileViewModel _vm;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _vm = ProfileViewModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final global = GlobalStateProvider.of(context);

      if (global.isLoggedIn && !_isInitialized) {
        await _vm.loadProfile(
          global.user!.id,
          global.user!.email!,
        );
        _isInitialized = true;
      }

      if (!mounted) return; // evita atualizar se o widget foi desmontado
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final globalState = GlobalStateProvider.of(context);

    return Center(
      child: globalState.isLoggedIn
          ? ListenableBuilder(
              listenable: _vm,
              builder: (context, _) =>
                  _buildProfileContent(context, globalState),
            )
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildProfileContent(BuildContext context, globalState) {
    if (_vm.isLoading) {
      return const CircularProgressIndicator();
    }

    if (_vm.errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_vm.errorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _vm.loadProfile(
              globalState.user!.id,
              globalState.user!.email!,
            ),
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    final data = _vm.profileData;
    final fullName = data['fullName'] ?? '';
    final email = data['email'] ?? '';
    final phone = data['phone'] ?? '';
    final birthDate = _vm.formatBirthDate(data['birthDate']);
    final address = data['address'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bem-vindo, ${fullName.split(' ').first}!'),
          const SizedBox(height: 16),
          _buildItem(Icons.person, 'Nome Completo', fullName),
          _buildItem(Icons.email, 'Email', email),
          _buildItem(Icons.phone, 'Telefone', phone),
          _buildItem(Icons.calendar_today, 'Nascimento', birthDate),
          _buildItem(Icons.home, 'Endereço', address),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.of(context).pushNamed(
                AppRoutes.editProfile,
                arguments: EditProfileViewArguments(
                  mode: EditProfileMode.editProfile,
                ),
              );
              _vm.invalidateCache();
              _vm.loadProfile(globalState.user!.id, globalState.user!.email!);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Perfil'),
          ),
          TextButton.icon(
            onPressed: globalState.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Você precisa fazer login para acessar o perfil.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
          child: const Text('Fazer Login / Cadastrar'),
        ),
      ],
    );
  }
}
