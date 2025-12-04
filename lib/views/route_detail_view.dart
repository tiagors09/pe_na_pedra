import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/trail_route.dart';
import 'package:pe_na_pedra/widget/route_info.dart';

class RouteDetailsView extends StatefulWidget {
  const RouteDetailsView({
    super.key,
  });

  @override
  State<RouteDetailsView> createState() => _RouteDetailsViewState();
}

class _RouteDetailsViewState extends State<RouteDetailsView> {
  late TrailRoute route;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      route = ModalRoute.of(context)!.settings.arguments as TrailRoute;
      _loaded = true;
    }
  }

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
