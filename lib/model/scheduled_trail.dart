import 'package:pe_na_pedra/model/trail_route.dart';

class ScheduledTrail {
  final String? id;
  final String routeId;
  TrailRoute? route; // carregada depois
  final String meetingPoint;
  final String meetingTime;
  final DateTime meetingDate;

  /// Lista de inscritos
  List<String> subscribers;

  ScheduledTrail({
    required this.routeId,
    required this.meetingPoint,
    required this.meetingTime,
    required this.meetingDate,
    this.route,
    this.id,
    List<String>? subscribers,
  }) : subscribers = subscribers ?? [];

  factory ScheduledTrail.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return ScheduledTrail(
      id: id,
      routeId: map['routeId'],
      meetingPoint: map['meetingPoint'] ?? '',
      meetingTime: map['meetingTime'] ?? '',
      meetingDate: DateTime.parse(map['meetingDate']),
      subscribers: (map['subscribers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'meetingPoint': meetingPoint,
      'meetingTime': meetingTime,
      'meetingDate': meetingDate.toIso8601String(),
      'subscribers': subscribers,
    };
  }
}
