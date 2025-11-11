import 'package:flutter/material.dart';
import 'package:pe_na_pedra/viewmodel/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = HomeViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (ctx, _) => IndexedStack(
          index: _viewModel.currentIndex,
          children: _viewModel.views,
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _viewModel,
        builder: (ctx, _) => NavigationBar(
          selectedIndex: _viewModel.currentIndex,
          onDestinationSelected: _viewModel.setCurrentIndex,
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
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
