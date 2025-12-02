import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class InitialRouteDeciderView extends StatefulWidget {
  const InitialRouteDeciderView({super.key});

  @override
  State<InitialRouteDeciderView> createState() =>
      _InitialRouteDeciderViewState();
}

class _InitialRouteDeciderViewState extends State<InitialRouteDeciderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final global = GlobalStateProvider.of(context);

      // user não logado → vai pro login
      if (!global.isLoggedIn || global.profile == null) {
        // normal → vai pra home
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return;
      }

      // usuário banido → manda pro login com aviso, ou outra tela se quiser
      if (global.profile != null ||
          global.profile!['role'] == UserRoles.banned.name) {
        Navigator.pushReplacementNamed(context, AppRoutes.banned);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
