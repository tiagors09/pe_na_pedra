import 'package:pe_na_pedra/controller/routes_controller.dart';
import 'package:pe_na_pedra/controller/scheduled_trails_controller.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';

class TrailsController {
  final ScheduledTrailsController _scheduled = ScheduledTrailsController();
  final RoutesController _routes = RoutesController();

  Future<List<ScheduledTrail>> fetchTrails({
    required String? idToken,
  }) async {
    // 1) Busca os agendamentos
    final scheduled = await _scheduled.fetchScheduledTrails(idToken: idToken);

    // 2) Busca TODAS as rotas
    final routes = await _routes.fetchRoutes(idToken: idToken);
    final routeById = {for (var r in routes) r.id!: r};

    // 3) associa rota ao scheduledTrail
    for (final sched in scheduled) {
      final route = routeById[sched.routeId];
      if (route != null) {
        sched.route = route;
      }
    }

    return scheduled;
  }

  //
  // SUBSCRIBE
  //
  Future<void> subscribeToTrail({
    required String? idToken,
    required String userId,
    required String trailId,
  }) async {
    await _scheduled.subscribeToTrail(
      idToken: idToken,
      userId: userId,
      trailId: trailId,
    );
  }

  //
  // UNSUBSCRIBE
  //
  Future<void> unsubscribeFromTrail({
    required String? idToken,
    required String userId,
    required String trailId,
  }) async {
    await _scheduled.unsubscribeFromTrail(
      idToken: idToken,
      userId: userId,
      trailId: trailId,
    );
  }
}
