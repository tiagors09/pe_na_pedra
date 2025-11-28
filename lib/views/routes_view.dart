import 'package:flutter/material.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rotas',
        ),
      ),
      body: const Center(
        child: Text(
          'Rotas',
        ),
      ),
    );
  }
}
