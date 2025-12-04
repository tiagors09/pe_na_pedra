import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/trail_route.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/dialog_launcher.dart';
import 'package:pe_na_pedra/viewmodel/routes_viewmodel.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  late RoutesViewModel _vm;

  @override
  void initState() {
    super.initState();

    _vm = RoutesViewModel();
    _vm.loadRoutes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final global = GlobalStateProvider.of(
      context,
    );

    _vm.idToken = global.idToken!;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Rotas'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).pushNamed(AppRoutes.routeForm);
                _vm.loadRoutes();
              },
            ),
          ],
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: _vm.isLoading,
          builder: (_, bool loading, __) {
            if (loading)
              return const Center(
                child: CircularProgressIndicator(),
              );

            return ValueListenableBuilder<String?>(
              valueListenable: _vm.error,
              builder: (_, String? error, __) {
                if (error != null)
                  return Center(
                    child: Text(
                      error,
                    ),
                  );

                return ValueListenableBuilder<List<TrailRoute>>(
                  valueListenable: _vm.routes,
                  builder: (_, List<TrailRoute> routes, __) {
                    if (routes.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhuma rota cadastrada',
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: routes.length,
                      itemBuilder: (_, int i) {
                        final TrailRoute route = routes[i];

                        return Dismissible(
                          key: ValueKey<String?>(route.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (_) async =>
                              await DialogLauncher.showConfirmDialog(
                            context,
                            title: 'Excluir Rota',
                            message:
                                'Deseja realmente excluir "${route.name}"?',
                            confirmText: 'Excluir',
                          ),
                          onDismissed: (_) => _vm.deleteRoute(
                            route.id!,
                          ),
                          child: ListTile(
                            title: Text(route.name),
                            leading: const Icon(
                              Icons.terrain,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                            onTap: () async {
                              // Editar usando o mesmo form
                              await Navigator.of(context).pushNamed(
                                AppRoutes.routeDetails,
                                arguments: route,
                              );
                              _vm.loadRoutes();
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      );
}
