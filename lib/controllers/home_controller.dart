import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:pe_na_pedra/views/profile_view.dart';
import 'package:pe_na_pedra/views/trails_view.dart';

class HomeController extends ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> views = [
    const TrailsView(),
    const ProfileView(),
  ];

  void handleNavigationTap(int value) {
    log(
      'Navigation tap: $value',
      name: 'HomeController',
    );

    currentIndex = value;

    log(
      'Current index updated: $currentIndex',
      name: 'HomeController',
    );

    notifyListeners();
  }
}
