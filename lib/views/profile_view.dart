import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
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
          global.userId!,
          global.idToken!,
        );
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final global = GlobalStateProvider.of(context);

    return global.isLoggedIn
        ? ListenableBuilder(
            listenable: _vm,
            builder: (_, __) => _buildProfileContent(context, global),
          )
        : _buildLoginPrompt(context);
  }

  Widget _buildProfileContent(BuildContext context, GlobalState global) {
    if (_vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vm.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _vm.errorMessage!,
              textAlign: TextAlign.center,
            ),
            Container(height: 12),
            ElevatedButton(
              onPressed: () => _vm.loadProfile(
                global.userId!,
                global.idToken!,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final data = _vm.profileData;
    final fullName = data['fullName'] ?? '';
    final phone = data['phone'] ?? '';
    final birthDate = _vm.formatBirthDate(data['birthDate']);
    final address = data['address'] ?? '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🟦 HEADER – Nome
            Container(
              margin: const EdgeInsets.only(bottom: 24, top: 16),
              child: Text(
                "Bem-vindo, ${fullName.split(' ').first}!",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🟦 INFORMAÇÕES
            _buildItem(Icons.person, 'Nome Completo', fullName),
            _buildItem(Icons.phone, 'Telefone', phone),
            _buildItem(Icons.calendar_today, 'Nascimento', birthDate),
            _buildItem(Icons.home, 'Endereço', address),

            // Espaço flexível para empurrar botões para baixo
            Expanded(child: Container()),

            // 🟦 BOTÕES
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(
                    AppRoutes.editProfile,
                    arguments: EditProfileViewArguments(
                      mode: EditProfileMode.editProfile,
                    ),
                  );
                  _vm.invalidateCache();
                  _vm.loadProfile(global.userId!, global.idToken!);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
              ),
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: TextButton.icon(
                onPressed: global.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          Container(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(height: 2),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Você precisa fazer login para acessar o perfil.'),
          Container(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
            child: const Text('Fazer Login / Cadastrar'),
          ),
        ],
      ),
    );
  }
}
