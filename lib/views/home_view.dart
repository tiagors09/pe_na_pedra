import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController _controller;

  @override
  void initState() {
    _controller = HomeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ListenableBuilder(
        listenable: _controller,
        builder: (ctx, _) => NavigationBar(
          selectedIndex: _controller.currentIndex,
          onDestinationSelected: _controller.handleNavigationTap,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.map,
              ),
              label: 'Trilhas',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (ctx, _) => _controller.views[_controller.currentIndex],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
