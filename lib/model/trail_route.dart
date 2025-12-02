import 'package:pe_na_pedra/model/route_point.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class TrailRoute {
  final String? id; // id opcional
  final String name;
  final Difficulty difficulty;
  final List<RoutePoint> points;
  final double distanceKm;
  final double speedKmh;
  final Duration elapsedTime;

  TrailRoute({
    this.id,
    required this.name,
    required this.difficulty,
    required this.points,
    required this.distanceKm,
    required this.speedKmh,
    required this.elapsedTime,
  });

  // Converter para Map (para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'difficulty': difficulty.name,
      'points': points
          .map((p) => {
                'lat': p.lat,
                'lng': p.lng,
              })
          .toList(),
      'distanceKm': distanceKm,
      'speedKmh': speedKmh,
      'elapsedTimeSec': elapsedTime.inSeconds,
    };
  }

  // Criar TrailRoute a partir de Map
  factory TrailRoute.fromMap(Map<String, dynamic> map, {String? id}) {
    final pts = (map['points'] as List)
        .map((p) => RoutePoint(p['lat'], p['lng']))
        .toList();

    return TrailRoute(
      id: id,
      name: map['name'] ?? '',
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => Difficulty.easy,
      ),
      points: pts,
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0,
      speedKmh: (map['speedKmh'] as num?)?.toDouble() ?? 0,
      elapsedTime: Duration(seconds: (map['elapsedTimeSec'] as int?) ?? 0),
    );
  }
}
