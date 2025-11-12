import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final globalState = GlobalStateProvider.of(context);

    final bool isAdmin = globalState.profile?['is_adm'] ?? false;
    _viewModel.isAdmin = isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log(
            'FAB Pressed',
            name: 'HomeView',
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (ctx, _) => IndexedStack(
          index: _viewModel.currentIndex,
          children: _viewModel.baseViews,
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _viewModel,
        builder: (ctx, _) => NavigationBar(
          selectedIndex: _viewModel.currentIndex,
          onDestinationSelected: (index) {
            _viewModel.setCurrentIndex(index);
          },
          destinations: _viewModel.destinations,
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
