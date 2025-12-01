import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pe_na_pedra/controller/routes_controller.dart';
import 'package:pe_na_pedra/model/trail_route.dart';
import 'package:pe_na_pedra/model/route_point.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class RouteFormViewModel extends ChangeNotifier {
  final _controller = RoutesController();

  final name = ValueNotifier<String>('');
  final difficulty = ValueNotifier<Difficulty?>(null);

  final points = ValueNotifier<List<RoutePoint>>([]);
  final ValueNotifier<double> distanceKm = ValueNotifier(0.0);
  final ValueNotifier<double> speedKmh = ValueNotifier(0.0);
  final ValueNotifier<Duration> elapsedTime = ValueNotifier(Duration.zero);

  final ValueNotifier<bool> isSaving = ValueNotifier(false);

  final formKey = GlobalKey<FormState>();

  // Botão só habilitado se tiver nome e rota
  ValueNotifier<bool> get canSave => ValueNotifier(
        name.value.isNotEmpty && points.value.isNotEmpty,
      );

  void setName(String value) {
    name.value = value;
    canSave.value = name.value.isNotEmpty && points.value.isNotEmpty;
  }

  void setDifficulty(Difficulty value) => difficulty.value = value;

  void setRecordedRoute(Map<String, dynamic>? result) {
    if (result == null) return;

    final pts = result['points'] as List<LatLng>;
    final dist = result['distanceKm'] as double;
    final spd = result['speedKmh'] as double;
    final elapsed = result['elapsedTime'] as Duration;

    points.value = pts
        .map(
          (p) => RoutePoint(
            p.latitude,
            p.longitude,
          ),
        )
        .toList();

    distanceKm.value = dist;
    speedKmh.value = spd;
    elapsedTime.value = elapsed;

    canSave.value = name.value.isNotEmpty && points.value.isNotEmpty;
  }

  Future<void> save(String idToken) async {
    if (!canSave.value) return;

    isSaving.value = true;

    try {
      final data = {
        'name': name.value,
        'difficulty': difficulty.value!.name,
        'points': points.value
            .map(
              (p) => {
                'lat': p.lat,
                'lng': p.lng,
              },
            )
            .toList(),
        'distanceKm': distanceKm.value,
        'speedKmh': speedKmh.value,
        'elapsedTimeSec': elapsedTime.value.inSeconds,
      };

      final route = TrailRoute.fromMap(data);

      await _controller.createRoute(route, idToken: '');

      log(
        'Saving to Firebase: $data',
        name: 'RouteFormViewModel',
      );
    } finally {
      isSaving.value = false;
    }
  }

  List<DropdownMenuItem<Difficulty>> get difficulties => Difficulty.values
      .map(
        (d) => DropdownMenuItem<Difficulty>(
          value: d,
          child: Text(
            d.label.toUpperCase(),
          ),
        ),
      )
      .toList();

  void onDifficultyChange(Difficulty? d) {
    if (d != null) {
      setDifficulty(
        d,
      );
    }
  }

  bool canTrackRoute() => points.value.isEmpty;
}
