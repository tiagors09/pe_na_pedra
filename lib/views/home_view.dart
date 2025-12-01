import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/viewmodel/home_viewmodel.dart';
import 'package:pe_na_pedra/views/profile_view.dart';

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

    final String role = globalState.profile?['role'] ?? UserRoles.hikker.name;
    _viewModel.role = role;

    _viewModel.setCurrentIndex(_viewModel.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_viewModel.title),
      ),
      drawer: const Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ProfileView(),
      ),
      body: IndexedStack(
        index: _viewModel.currentIndex,
        children: _viewModel.baseViews,
      ),
      bottomNavigationBar: _viewModel.isAdmin
          ? NavigationBar(
              selectedIndex: _viewModel.currentIndex,
              onDestinationSelected: _viewModel.setCurrentIndex,
              destinations: _viewModel.destinations,
            )
          : const BottomAppBar(
              color: Color(0xFFF5D204),
              child: Icon(
                Icons.map,
                color: Color(0xFF745F04),
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
