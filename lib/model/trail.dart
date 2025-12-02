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
    required this.trailLocation,
    required this.meetingDate,
    required this.meetingTime,
    required this.spots,
    required this.difficulty,
    required this.route,
    this.meetingAddress,
    this.trailAddress,
  });

  factory Trail.fromMap(String id, Map<String, dynamic> map) {
    List<LatLng> parseRoute(dynamic routeRaw) {
      if (routeRaw == null) return <LatLng>[];
      final List<dynamic> list = (routeRaw as List<dynamic>?) ?? <dynamic>[];
      return list.map<LatLng>((dynamic p) {
        final double lat = (p['lat'] as num).toDouble();
        final double lng = (p['lng'] as num).toDouble();
        return LatLng(lat, lng);
      }).toList();
    }

    final Map<String, dynamic> mp = map['meetingPoint'] as Map<String, dynamic>;
    final Map<String, dynamic> tl = map['trailLocation'] as Map<String, dynamic>;

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
      meetingDate: DateTime.tryParse(map['meetingDate'] ?? '') ?? DateTime.now(),
      meetingTime: map['meetingTime'] ?? '00:00',
      spots: (map['spots'] as num?)?.toInt() ?? 0,
      difficulty: map['difficulty'] ?? 'easy',
      route: parseRoute(map['route']),
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'meetingPoint': <String, double>{
          'lat': meetingPoint.latitude,
          'lng': meetingPoint.longitude,
        },
        'meetingAddress': meetingAddress,
        'trailLocation': <String, double>{
          'lat': trailLocation.latitude,
          'lng': trailLocation.longitude,
        },
        'trailAddress': trailAddress,
        'meetingDate': meetingDate.toIso8601String(),
        'meetingTime': meetingTime,
        'spots': spots,
        'difficulty': difficulty,
        'route': route
            .map(
              (LatLng p) => <String, double>{
                'lat': p.latitude,
                'lng': p.longitude,
              },
            )
            .toList(),
      };
}
