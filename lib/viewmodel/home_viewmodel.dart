import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/views/adm_view.dart';
import 'package:pe_na_pedra/views/trails_view.dart';

class HomeViewModel extends ChangeNotifier {
  final labels = ['Trilhas', 'Painel Administrativo'];

  String title = 'Trilhas';

  String role = UserRoles.hikker.name;

  int currentIndex = 0;

  bool get isAdmin => role == UserRoles.adm.name;

  void changeTitle(String label) {
    title = label;
  }

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
        )
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
    currentIndex = index.clamp(0, baseViews.length - 1);
    title = labels[currentIndex];
    notifyListeners();
  }
}
