import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/viewmodel/calendar_viewmodel.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late CalendarViewmodel vm;

  @override
  void initState() {
    super.initState();
    vm = CalendarViewmodel();
  }

  bool _tokenSet = false;

  @override
  void didChangeDependencies() {
    final global = GlobalStateProvider.of(context);

    if (!_tokenSet) {
      vm.idToken = global.idToken!;
      _tokenSet = true;
      vm.load();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de trilhas'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context)
                  .pushNamed(AppRoutes.scheduledTrailForm);

              if (result != null) {
                vm.load();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.trailsByMonth,
        builder: (_, map, __) {
          if (vm.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (map.isEmpty) {
            return const Center(
              child: Text("Nenhuma trilha agendada."),
            );
          }

          return ListView(
            children: map.entries.map((e) {
              return ExpansionTile(
                key: ValueKey(e.key),
                title: Text(e.key),
                children: e.value.map((trail) {
                  final route = vm.routesById[trail.routeId];
                  final routeName = route?.name ?? "Rota desconhecida";

                  return Dismissible(
                    key: ValueKey(trail.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Excluir trilha?"),
                          content: Text(
                            "Deseja excluir a trilha '$routeName'?",
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text("Excluir"),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) {
                      vm.delete(trail.id!);
                    },
                    child: ListTile(
                      title: Text(routeName),
                      subtitle:
                          Text("${trail.meetingPoint} - ${trail.meetingTime}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.of(context).pushNamed(
                            AppRoutes.scheduledTrailForm,
                            arguments: trail,
                          );

                          if (result != null) vm.load();
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
