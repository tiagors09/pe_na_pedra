import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pe_na_pedra/viewmodel/track_route_viewmodel.dart';

class TrackRouteView extends StatefulWidget {
  const TrackRouteView({super.key});

  @override
  State<TrackRouteView> createState() => _TrackRouteViewState();
}

class _TrackRouteViewState extends State<TrackRouteView> {
  final vm = TrackRouteViewModel();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    vm.initLocation().then((_) {
      if (mounted) setState(() {});
      _mapController.move(vm.initialCenter, 16);
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: vm.hasInitialLocation,
        builder: (_, hasLocation, __) {
          if (!hasLocation) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: vm.initialCenter,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'br.com.tiagors09.penapedra',
                  ),
                  ValueListenableBuilder<List<LatLng>>(
                    valueListenable: vm.points,
                    builder: (_, points, __) {
                      return PolylineLayer(
                        polylines: [
                          if (points.length > 1)
                            Polyline(
                              points: points,
                              strokeWidth: 10,
                              color: Colors.blueAccent.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          if (points.length > 1)
                            Polyline(
                              points: points,
                              strokeWidth: 4,
                              color: Colors.blueAccent,
                            ),
                        ],
                      );
                    },
                  ),
                  ValueListenableBuilder<List<LatLng>>(
                    valueListenable: vm.points,
                    builder: (_, points, __) {
                      if (points.isEmpty) return const SizedBox();
                      return MarkerLayer(
                        markers: [
                          Marker(
                            point: points.first,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.flag,
                                color: Colors.green, size: 32),
                          ),
                          Marker(
                            point: points.last,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.my_location,
                                color: Colors.red, size: 34),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Positioned(top: 40, left: 0, right: 0, child: _infoOverlay()),
              Positioned(bottom: 0, left: 0, right: 0, child: _buttonsRow()),
            ],
          );
        },
      ),
    );
  }

  Widget _infoOverlay() {
    return Card(
      color: Colors.white.withValues(
        alpha: 0.9,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ValueListenableBuilder<Duration>(
              valueListenable: vm.elapsedTime,
              builder: (_, elapsed, __) => _infoTile(
                'TEMPO',
                vm.formattedTime(),
              ),
            ),
            ValueListenableBuilder<double>(
              valueListenable: vm.totalDistanceKm,
              builder: (_, dist, __) => _infoTile(
                'DIST',
                '${dist.toStringAsFixed(2)} km',
              ),
            ),
            ValueListenableBuilder<double>(
              valueListenable: vm.speedKmh,
              builder: (_, speed, __) => _infoTile(
                'VEL',
                '${speed.toStringAsFixed(1)} km/h',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buttonsRow() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: vm.isRecording,
                builder: (_, isRecording, __) {
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(
                        50,
                      ),
                    ),
                    onPressed: () {
                      if (!isRecording) {
                        vm.startRecording();
                      } else {
                        final data = vm.stopRecording();

                        if (data != null && data.isNotEmpty) {
                          vm.setData(data);

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Rota salva!',
                              ),
                              showCloseIcon: true,
                            ),
                          );
                        }
                      }
                    },
                    icon: Icon(
                      isRecording ? Icons.stop : Icons.fiber_manual_record,
                    ),
                    label: Text(
                      isRecording ? 'Parar' : 'Gravar',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder<List<LatLng>>(
              valueListenable: vm.points,
              builder: (_, points, __) {
                if (points.isEmpty) {
                  return const SizedBox(
                    width: 8,
                  );
                }

                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      64,
                      50,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      vm.mapData,
                    );
                  },
                  icon: const Icon(
                    Icons.save,
                  ),
                  label: const Text(
                    'Salvar',
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  64,
                  50,
                ),
              ),
              onPressed: () {
                if (vm.points.value.isNotEmpty) {
                  _mapController.move(
                    vm.points.value.last,
                    17,
                  );
                }
              },
              icon: const Icon(
                Icons.my_location,
              ),
              label: const Text(
                'Ir',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
