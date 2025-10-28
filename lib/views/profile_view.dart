import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/providers/global_state_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final globalState = GlobalStateProvider.of(context);

    log(
      'Construindo ProfileView - isLoggedIn: ${globalState.isLoggedIn}',
      name: 'ProfileView',
    );

    return Center(
      child: globalState.isLoggedIn
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Olá, ${globalState.user?.email ?? "Usuário"}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    globalState.logout();
                    log(
                      'Usuário deslogado',
                      name: 'ProfileView',
                      level: 800,
                    );
                  },
                  child: const Text('Sair'),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Você precisa fazer login ou se cadastrar para acessar o perfil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    log(
                      'Botão de login pressionado',
                      name: 'ProfileView',
                    );
                    Navigator.of(context).pushNamed(
                      '/login',
                    );
                  },
                  child: const Text(
                    'Fazer Login / Cadastrar',
                  ),
                ),
              ],
            ),
    );
  }
}
