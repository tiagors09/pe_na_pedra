import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/route_item.dart';
import 'package:pe_na_pedra/model/route_point.dart';

class RoutesViewModel with ChangeNotifier {
  final List<RouteItem> _routes = [
    RouteItem(
      id: '1',
      name: "Trilha da Cachoeira Azul",
      description: "Trilha leve com queda d'água.",
      points: [
        RoutePoint(-22.9068, -43.1729), // início
        RoutePoint(-22.9055, -43.1702),
        RoutePoint(-22.9039, -43.1687),
        RoutePoint(-22.9025, -43.1670), // cachoeira
      ],
    ),
    RouteItem(
      id: '2',
      name: "Pico da Serra Alta",
      description: "Subida forte, visual incrível.",
      points: [
        RoutePoint(-25.4284, -49.2733),
        RoutePoint(-25.4299, -49.2701),
        RoutePoint(-25.4310, -49.2678),
        RoutePoint(-25.4327, -49.2654), // pico
      ],
    ),
    RouteItem(
      id: '3',
      name: "Vale Encantado",
      description: "Trilha média, floresta fechada.",
      points: [
        RoutePoint(-21.1700, -47.8100),
        RoutePoint(-21.1690, -47.8082),
        RoutePoint(-21.1680, -47.8067),
        RoutePoint(-21.1670, -47.8049),
      ],
    ),
  ];

  List<RouteItem> get routes => List.unmodifiable(_routes);

  void deleteRoute(String id) {
    _routes.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
