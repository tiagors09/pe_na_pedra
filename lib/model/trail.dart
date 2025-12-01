import 'package:latlong2/latlong.dart';

class Trail {
  final String id;
  final String name;
  final LatLng meetingPoint;
  final String? meetingAddress;
  final LatLng trailLocation;
  final String? trailAddress;
  final DateTime meetingDate;
  final String meetingTime; // HH:mm
  final int spots;
  final String difficulty; // 'easy'/'medium'/'hard'
  final List<LatLng> route;

  Trail({
    required this.id,
    required this.name,
    required this.meetingPoint,
    this.meetingAddress,
    required this.trailLocation,
    this.trailAddress,
    required this.meetingDate,
    required this.meetingTime,
    required this.spots,
    required this.difficulty,
    required this.route,
  });

  factory Trail.fromMap(String id, Map<String, dynamic> map) {
    List<LatLng> parseRoute(dynamic routeRaw) {
      if (routeRaw == null) return [];
      final list = (routeRaw as List?) ?? [];
      return list.map((p) {
        final lat = (p['lat'] as num).toDouble();
        final lng = (p['lng'] as num).toDouble();
        return LatLng(lat, lng);
      }).toList();
    }

    final mp = map['meetingPoint'] as Map<String, dynamic>;
    final tl = map['trailLocation'] as Map<String, dynamic>;

    return Trail(
      id: id,
      name: map['name'] ?? '',
      meetingPoint: LatLng(
        (mp['lat'] as num).toDouble(),
        (mp['lng'] as num).toDouble(),
      ),
      meetingAddress: map['meetingAddress'],
      trailLocation: LatLng(
        (tl['lat'] as num).toDouble(),
        (tl['lng'] as num).toDouble(),
      ),
      trailAddress: map['trailAddress'],
      meetingDate:
          DateTime.tryParse(map['meetingDate'] ?? '') ?? DateTime.now(),
      meetingTime: map['meetingTime'] ?? '00:00',
      spots: (map['spots'] as num?)?.toInt() ?? 0,
      difficulty: map['difficulty'] ?? 'easy',
      route: parseRoute(map['route']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'meetingPoint': {
        'lat': meetingPoint.latitude,
        'lng': meetingPoint.longitude
      },
      'meetingAddress': meetingAddress,
      'trailLocation': {
        'lat': trailLocation.latitude,
        'lng': trailLocation.longitude
      },
      'trailAddress': trailAddress,
      'meetingDate': meetingDate.toIso8601String(),
      'meetingTime': meetingTime,
      'spots': spots,
      'difficulty': difficulty,
      'route': route
          .map(
            (p) => {
              'lat': p.latitude,
              'lng': p.longitude,
            },
          )
          .toList(),
    };
  }
}
