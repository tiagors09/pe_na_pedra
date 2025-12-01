import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pe_na_pedra/model/route_item.dart';

class RouteDetailsView extends StatelessWidget {
  final RouteItem route;

  const RouteDetailsView({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final List<LatLng> latLngPoints = route.points
        .map(
          (p) => LatLng(
            p.lat,
            p.lng,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: latLngPoints.first,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "br.com.tiagors09.penapedra.app",
          ),
          MarkerLayer(
            markers: [
              // início
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
      ),
    );
  }
}
