import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/route_item.dart';
import 'package:pe_na_pedra/widget/route_info.dart';

class RouteDetailsView extends StatelessWidget {
  final RouteItem route;

  const RouteDetailsView({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          route.name,
        ),
      ),
      body: RouteInfo(
        points: route.points,
      ),
    );
  }
}
