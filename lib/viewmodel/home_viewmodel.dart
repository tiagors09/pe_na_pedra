import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/views/profile_view.dart';
import 'package:pe_na_pedra/views/trails_view.dart';

class HomeViewModel extends ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> views = const [
    TrailsView(),
    ProfileView(),
  ];

  void setCurrentIndex(int index) {
    log('Atualizando índice para $index', name: 'HomeViewModel');
    currentIndex = index;
    notifyListeners();
  }
}
