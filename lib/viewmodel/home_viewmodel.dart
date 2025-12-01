import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/views/adm_view.dart';
import 'package:pe_na_pedra/views/trails_view.dart';

class HomeViewModel {
  // índice atual
  final currentIndex = ValueNotifier<int>(0);

  // título atual
  final title = ValueNotifier<String>('Trilhas');

  // role do usuário
  final role = ValueNotifier<String>(UserRoles.hikker.name);

  bool get isAdmin => role.value == UserRoles.adm.name;

  List<Widget> get baseViews {
    final list = <Widget>[
      const TrailsView(),
    ];

    if (isAdmin) list.add(const AdmView());

    return list;
  }

  List<NavigationDestination> get destinations {
    if (isAdmin) {
      return const [
        NavigationDestination(
          icon: Icon(Icons.map),
          label: 'Trilhas',
        ),
        NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      ];
    }

    return const [
      NavigationDestination(
        icon: Icon(Icons.map),
        label: 'Trilhas',
      ),
    ];
  }

  void setCurrentIndex(int index) {
    final safeIndex = index.clamp(0, baseViews.length - 1);
    currentIndex.value = safeIndex;
    title.value = safeIndex == 0 ? 'Trilhas' : 'Painel Administrativo';
  }

  void dispose() {
    currentIndex.dispose();
    title.dispose();
    role.dispose();
  }
}
