import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';

class AdmView extends StatelessWidget {
  const AdmView({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _AdmButton(
        icon: Icons.terrain,
        label: 'Cadastrar Rotas',
        onTap: () {},
      ),
      _AdmButton(
        icon: Icons.calendar_today,
        label: 'Calendário de trilhas',
        onTap: () {},
      ),
      _AdmButton(
        icon: Icons.group,
        label: 'Trilheiros',
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.users,
          );
        },
      ),
      _AdmButton(
        icon: Icons.settings,
        label: 'Configurações',
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Administrativo"),
      ),
      body: SafeArea(
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
      ),
    );
  }
}

class _AdmButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdmButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // evita estourar o espaço
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // segurança
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
