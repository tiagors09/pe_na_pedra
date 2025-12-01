import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/route_point.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class RouteFormViewModel extends ChangeNotifier {
  final name = ValueNotifier<String>('');
  final difficulty = ValueNotifier<Difficulty>(Difficulty.easy);
  final points = ValueNotifier<List<RoutePoint>>([]);

  void setName(String value) {
    name.value = value;
  }

  void setDifficulty(Difficulty value) {
    difficulty.value = value;
  }

  void setRecordedRoute(List<RoutePoint> value) {
    points.value = value;
  }

  Future<void> save() async {
    final data = {
      'name': name.value,
      'difficulty': difficulty.value.name,
      'points': points.value
          .map(
            (
              p,
            ) =>
                {
              'lat': p.lat,
              'lng': p.lng,
            },
          )
          .toList(),
    };

    log(
      'Saving to Firebase: $data',
      name: 'RouteFormViewModel',
    );
  }

  List<DropdownMenuItem<Difficulty>> get difficulties => Difficulty.values
      .map<DropdownMenuItem<Difficulty>>(
        (d) => DropdownMenuItem<Difficulty>(
          value: d,
          child: Text(
            d.label.toUpperCase(),
          ),
        ),
      )
      .toList();

  void onDifficultyChange(d) {
    if (d != null) {
      setDifficulty(
        d,
      );
    }
  }

  bool canTrackRoute() {
    return points.value.isEmpty;
  }
}
