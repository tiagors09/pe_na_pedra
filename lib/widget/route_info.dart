import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pe_na_pedra/model/route_point.dart';

class RouteInfo extends StatelessWidget {
  final List<RoutePoint> points;
  final InteractionOptions interactionOptions;

  const RouteInfo({
    super.key,
    required this.points,
    this.interactionOptions = const InteractionOptions(),
  });

  @override
  Widget build(BuildContext context) {
    final List<LatLng> latLngPoints = points
        .map<LatLng>(
          (RoutePoint p) => LatLng(
            p.lat,
            p.lng,
          ),
        )
        .toList();

    return FlutterMap(
      options: MapOptions(
        initialCenter: latLngPoints.first,
        initialZoom: 14,
        interactionOptions: interactionOptions,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'br.com.tiagors09.penapedra.app',
        ),
        MarkerLayer(
          markers: <Marker>[
            Marker(
              width: 40,
              height: 40,
              point: latLngPoints.first,
              child: const Icon(
                Icons.flag,
                color: Colors.green,
                size: 36,
              ),
            ),
            Marker(
              width: 40,
              height: 40,
              point: latLngPoints.last,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 36,
              ),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: latLngPoints,
              strokeWidth: 4,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
