import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/views/adm_view.dart';
import 'package:pe_na_pedra/views/profile_view.dart';
import 'package:pe_na_pedra/views/trails_view.dart';

class HomeViewModel extends ChangeNotifier {
  String role = UserRoles.hikker.name;

  int currentIndex = 0;

  bool get isAdmin => role == UserRoles.adm.name;

  /// Views padrão (sem admin)
  List<Widget> get baseViews => [
        const TrailsView(),
        if (isAdmin) const AdmView(),
        const ProfileView(),
      ];

  // 🔹 Monta as opções da barra inferior
  List<NavigationDestination> get destinations => [
        const NavigationDestination(
          icon: Icon(Icons.map),
          label: 'Trilhas',
        ),
        if (isAdmin)
          const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        const NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];

  /// Atualiza o índice do menu
  void setCurrentIndex(int index) {
    log('Atualizando índice para $index', name: 'HomeViewModel');
    currentIndex = index.clamp(0, baseViews.length - 1);
    notifyListeners();
  }
}
