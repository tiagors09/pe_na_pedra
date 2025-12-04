import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/widget/adm_button.dart';

class AdmView extends StatelessWidget {
  const AdmView({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      AdmButton(
        icon: Icons.terrain,
        label: 'Rotas',
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.routes,
          );
        },
      ),
      AdmButton(
        icon: Icons.calendar_today,
        label: 'Calendário de trilhas',
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.calendar,
          );
        },
      ),
      AdmButton(
        icon: Icons.group,
        label: 'Trilheiros',
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.users,
          );
        },
      ),
      /*
      const AdmButton(
        icon: Icons.settings,
        label: 'Configurações',
        onTap: null,
      ),
      */
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // evita overflow vertical
          ),
          itemBuilder: (context, i) => buttons[i],
        ),
      ),
    );
  }
}
