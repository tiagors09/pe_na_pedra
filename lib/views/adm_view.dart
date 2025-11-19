import 'package:flutter/material.dart';

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
        label: 'Trilha do Dia',
        onTap: () {},
      ),
      _AdmButton(
        icon: Icons.group,
        label: 'Usuários',
        onTap: () {},
      ),
      _AdmButton(
        icon: Icons.settings,
        label: 'Configurações',
        onTap: () {},
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: buttons.map((b) => b).toList(),
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
