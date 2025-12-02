import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/routes_controller.dart';
import 'package:pe_na_pedra/model/trail_route.dart';

class RoutesViewModel {
  final RoutesController _controller = RoutesController();

  final ValueNotifier<List<TrailRoute>> routes = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);

  final String? idToken;

  RoutesViewModel({this.idToken});

  Future<void> loadRoutes() async {
    isLoading.value = true;
    error.value = null;

    try {
      final fetched = await _controller.fetchRoutes(idToken: idToken);
      routes.value = fetched;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRoute(String id) async {
    try {
      await _controller.deleteRoute(id, idToken: idToken);
      routes.value = routes.value.where((r) => r.id != id).toList();
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> saveRoute(TrailRoute route, {String? id}) async {
    if (id == null) {
      // Criar nova rota
      await _controller.createRoute(route, idToken: idToken);
    } else {
      // Atualizar rota existente
      await _controller.updateRoute(id, route, idToken: idToken);
    }
    await loadRoutes();
  }
}
