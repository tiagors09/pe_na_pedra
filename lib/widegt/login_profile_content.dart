import 'package:flutter/material.dart';
import 'package:pe_na_pedra/widegt/login_profile_content_item.dart';

class LoginProfileContent extends StatelessWidget {
  final String fullName;
  final String phone;
  final String birthDate;
  final String address;

  final Future<void> Function() onEditProfile;
  final VoidCallback onLogout;

  const LoginProfileContent({
    super.key,
    required this.fullName,
    required this.phone,
    required this.birthDate,
    required this.address,
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = fullName.split(' ').first;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 24,
                top: 16,
              ),
              child: Text(
                "Bem-vindo, $firstName!",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LoginProfileContentItem(
              icon: Icons.person,
              label: 'Nome Completo',
              value: fullName,
            ),
            LoginProfileContentItem(
              icon: Icons.phone,
              label: 'Telefone',
              value: phone,
            ),
            LoginProfileContentItem(
              icon: Icons.calendar_today,
              label: 'Nascimento',
              value: birthDate,
            ),
            LoginProfileContentItem(
              icon: Icons.home,
              label: 'Endereço',
              value: address,
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onEditProfile,
                icon: const Icon(
                  Icons.edit,
                ),
                label: const Text(
                  'Editar Perfil',
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'Sair',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
