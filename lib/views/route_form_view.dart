import 'package:flutter/material.dart';

class RouteFormView extends StatefulWidget {
  const RouteFormView({super.key});

  @override
  State<RouteFormView> createState() => _RouteFormViewState();
}

class _RouteFormViewState extends State<RouteFormView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'RouteFormView',
        ),
      ),
    );
  }
}
