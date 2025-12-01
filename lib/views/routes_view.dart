import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/dialog_launcher.dart';
import 'package:pe_na_pedra/viewmodel/routes_viewmodel.dart';
import 'package:pe_na_pedra/views/route_detail_view.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  late RoutesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RoutesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final routes = _viewModel.routes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.routeForm,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: routes.isEmpty
          ? const Center(child: Text("Nenhuma rota cadastrada"))
          : ListView.builder(
              itemCount: routes.length,
              itemBuilder: (_, i) {
                final route = routes[i];

                return Dismissible(
                  key: ValueKey(route.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await DialogLauncher.showConfirmDialog(
                      context,
                      title: "Excluir Rota",
                      message:
                          "Deseja realmente excluir a rota '${route.name}'?",
                      confirmText: "Excluir",
                    );
                  },
                  onDismissed: (_) => _viewModel.deleteRoute(
                    route.id,
                  ),
                  child: ListTile(
                    title: Text(
                      route.name,
                    ),
                    subtitle: Text(
                      route.description,
                    ),
                    leading: const Icon(
                      Icons.terrain,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RouteDetailsView(
                            route: route,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
