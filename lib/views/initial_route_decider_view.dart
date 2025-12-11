import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/views/banned_view.dart';
import 'package:pe_na_pedra/views/home_view.dart';

class InitialRouteDeciderView extends StatelessWidget {
  const InitialRouteDeciderView({super.key});

  @override
  Widget build(BuildContext context) {
    final global = GlobalStateProvider.of(context);

    // Usuário não logado → tela Home (ou Login, se quiser)
    if (!global.isLoggedIn || global.profile == null) {
      return const HomeView();
    }

    // Usuário banido → tela de banimento
    final isBanned = global.profile!['role'] == UserRoles.banned.name;

    return isBanned ? const BannedView() : const HomeView();
  }
}
