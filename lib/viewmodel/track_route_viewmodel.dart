import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class TrackRouteViewModel {
  // Estado da gravação
  final ValueNotifier<bool> isRecording = ValueNotifier(false);

  // Localização inicial
  final ValueNotifier<bool> hasInitialLocation = ValueNotifier(false);
  LatLng initialCenter = const LatLng(0, 0);

  // Pontos da rota
  final ValueNotifier<List<LatLng>> points = ValueNotifier([]);

  // Distância total em km
  final ValueNotifier<double> totalDistanceKm = ValueNotifier(0.0);

  // Velocidade em km/h
  final ValueNotifier<double> speedKmh = ValueNotifier(0.0);

  // Tempo decorrido
  final ValueNotifier<Duration> elapsedTime = ValueNotifier(Duration.zero);

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  StreamSubscription<Position>? _locationStream;

  final Distance _distance = const Distance();

  final ValueNotifier<Map<String, dynamic>> data =
      ValueNotifier<Map<String, dynamic>>({});

  void setData(Map<String, dynamic> value) {
    data.value = value;
  }

  Map<String, dynamic> get mapData => data.value;

  Future<void> initLocation() async {
    final perm = await Geolocator.requestPermission();

    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    initialCenter = LatLng(pos.latitude, pos.longitude);
    hasInitialLocation.value = true;
  }

  void startRecording() {
    if (isRecording.value) return;

    points.value = [];
    totalDistanceKm.value = 0;
    speedKmh.value = 0;
    _stopwatch.reset();
    _stopwatch.start();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedTime.value = _stopwatch.elapsed;
    });

    isRecording.value = true;

    _locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 3,
      ),
    ).listen((pos) {
      final point = LatLng(pos.latitude, pos.longitude);

      if (points.value.isNotEmpty) {
        final distanceMeters = _distance.distance(points.value.last, point);
        totalDistanceKm.value += distanceMeters / 1000.0;
      }

      speedKmh.value = pos.speed * 3.6;

      points.value = [...points.value, point];
    });
  }

  Map<String, dynamic>? stopRecording() {
    if (!isRecording.value) return null;

    isRecording.value = false;
    _locationStream?.cancel();
    _timer?.cancel();
    _stopwatch.stop();

    if (points.value.isEmpty) return null;

    return {
      'points': List<LatLng>.from(points.value),
      'distanceKm': totalDistanceKm.value,
      'speedKmh': speedKmh.value,
      'elapsedTime': _stopwatch.elapsed,
    };
  }

  void reset() {
    points.value = [];
    totalDistanceKm.value = 0;
    speedKmh.value = 0;
    _stopwatch.reset();
    elapsedTime.value = Duration.zero;
    isRecording.value = false;
  }

  String formattedTime() {
    final s = _stopwatch.elapsed.inSeconds;
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;

    if (h > 0) {
      return "$h:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
    }

    return "${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  void dispose() {
    _locationStream?.cancel();
    _timer?.cancel();
  }
}
