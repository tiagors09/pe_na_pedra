import 'package:pe_na_pedra/model/route_point.dart';

class RouteItem {
  final String id;
  final String name;
  final String description;
  final List<RoutePoint> points;

  RouteItem({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
  });
}
