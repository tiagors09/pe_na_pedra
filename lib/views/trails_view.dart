import 'package:flutter/material.dart';

class TrailsView extends StatefulWidget {
  const TrailsView({super.key});

  @override
  State<TrailsView> createState() => _TrailsViewState();
}

class _TrailsViewState extends State<TrailsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Trilhas View',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
