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
  late final HomeViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = HomeViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final globalState = GlobalStateProvider.of(
      context,
    );

    final String r = globalState.profile?['role'] ?? UserRoles.hikker.name;

    _vm.role.value = r;

    _vm.setCurrentIndex(_vm.currentIndex.value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _vm.title,
      builder: (_, title, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              title,
            ),
          ),
          drawer: const Drawer(
            child: ProfileView(),
          ),
          body: ValueListenableBuilder(
            valueListenable: _vm.currentIndex,
            builder: (_, index, __) {
              return IndexedStack(
                index: index,
                children: _vm.baseViews,
              );
            },
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _vm.role,
            builder: (_, role, __) {
              final isAdmin = role == UserRoles.adm.name;

              return isAdmin
                  ? ValueListenableBuilder(
                      valueListenable: _vm.currentIndex,
                      builder: (_, index, __) {
                        return NavigationBar(
                          selectedIndex: index,
                          onDestinationSelected: _vm.setCurrentIndex,
                          destinations: _vm.destinations,
                        );
                      },
                    )
                  : const BottomAppBar(
                      color: Color(
                        0xFFF5D204,
                      ),
                      child: Icon(
                        Icons.map,
                        color: Color(
                          0xFF745F04,
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }
}
