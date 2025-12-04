import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/routes_controller.dart';
import 'package:pe_na_pedra/controller/scheduled_trails_controller.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';
import 'package:pe_na_pedra/model/trail_route.dart';

class CalendarViewmodel with ChangeNotifier {
  final ScheduledTrailsController _controller = ScheduledTrailsController();
  final RoutesController _routesController = RoutesController();

  late String idToken;

  final isLoading = ValueNotifier<bool>(false);
  final trailsByMonth = ValueNotifier<Map<String, List<ScheduledTrail>>>({});
  final routesById = <String, TrailRoute>{};

  Future<void> load() async {
    isLoading.value = true;

    //
    // 1) Carrega rotas
    //
    final allRoutes = await _routesController.fetchRoutes(idToken: idToken);
    routesById.clear();
    for (final r in allRoutes) {
      if (r.id != null) {
        routesById[r.id!] = r;
      }
    }

    //
    // 2) Carrega trilhas agendadas
    //
    final scheduled = await _controller.fetchScheduledTrails(
      idToken: idToken,
    );

    scheduled.forEach(
      (s) => log(
        s.toMap().toString(),
        name: 'CalendarViewmodel',
      ),
    );

    //
    // 3) Associa rota a cada trilha
    //
    for (final s in scheduled) {
      s.route = routesById[s.routeId]; // <<<<< AQUI O VÍNCULO
    }

    //
    // 4) Agrupar por mês
    //
    trailsByMonth.value = _groupByMonth(scheduled);

    isLoading.value = false;
    notifyListeners();
  }

  Map<String, List<ScheduledTrail>> _groupByMonth(List<ScheduledTrail> list) {
    final map = <String, List<ScheduledTrail>>{};

    for (final t in list) {
      final key = "${t.meetingDate.month}/${t.meetingDate.year}";
      map.putIfAbsent(key, () => []);
      map[key]!.add(t);
    }

    return map;
  }

  Future<void> delete(String id) async {
    await _controller.deleteScheduledTrail(id, idToken: idToken);
    await load();
  }
}
