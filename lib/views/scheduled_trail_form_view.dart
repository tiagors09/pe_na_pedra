import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/scheduled_trail_form_viewmodel.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';

class ScheduledTrailFormView extends StatefulWidget {
  const ScheduledTrailFormView({super.key});

  @override
  State<ScheduledTrailFormView> createState() => _ScheduledTrailFormViewState();
}

class _ScheduledTrailFormViewState extends State<ScheduledTrailFormView> {
  late final ScheduledTrailFormViewModel vm;

  bool loadedArgs = false;

  @override
  void initState() {
    super.initState();
    vm = ScheduledTrailFormViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final global = GlobalStateProvider.of(context);
    vm.idToken = global.idToken!;

    if (!loadedArgs) {
      vm.editing =
          ModalRoute.of(context)!.settings.arguments as ScheduledTrail?;
      loadedArgs = true;
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    await vm.loadRoutes();

    if (vm.editing != null) {
      log(vm.editing!.toMap().toString(), name: 'ScheduledTrailFormView');

      vm.meetingPointController.text = vm.editing!.meetingPoint;
      vm.meetingDate.value = vm.editing!.meetingDate;

      final split = vm.editing!.meetingTime.split(':');
      vm.meetingTime.value = TimeOfDay(
        hour: int.parse(split[0]),
        minute: int.parse(split[1]),
      );

      vm.selectedRoute.value =
          vm.routes.value.firstWhere((r) => r.id == vm.editing!.routeId);
      vm.isUpdating = true;
    } else {
      vm.isUpdating = false;
    }
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agendar Trilha")),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.055,
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          child: ElevatedButton(
            child: ValueListenableBuilder(
              valueListenable: vm.isSaving,
              builder: (_, saving, __) {
                return saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Salvar");
              },
            ),
            onPressed: () async {
              if (vm.isSaving.value) return;

              final scheduled = vm.submit();
              if (scheduled == null) return;

              final ok = await vm.saveToFirebase(scheduled);

              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Trilha agendada com sucesso!")),
                );
                Navigator.pop(context, scheduled);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Erro ao salvar")),
                );
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: vm.formKey,
          child: ListView(
            children: [
              // -------------------- ROTAS --------------------
              ValueListenableBuilder(
                valueListenable: vm.isLoadingRoutes,
                builder: (_, loading, __) {
                  if (loading)
                    return const Center(child: CircularProgressIndicator());

                  return ValueListenableBuilder(
                    valueListenable: vm.routes,
                    builder: (_, routes, __) {
                      return ValueListenableBuilder(
                        valueListenable: vm.selectedRoute,
                        builder: (_, selected, __) {
                          return DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: "Rota",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: selected,
                            items: routes
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r.name),
                                  ),
                                )
                                .toList(),
                            validator: (v) =>
                                v == null ? "Selecione uma rota" : null,
                            onChanged: (value) {
                              vm.selectedRoute.value = value;
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // -------------------- DATA --------------------
              ValueListenableBuilder<DateTime?>(
                valueListenable: vm.meetingDate,
                builder: (_, date, __) {
                  return InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: date ?? DateTime.now(),
                      );
                      if (picked != null) vm.meetingDate.value = picked;
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Data",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        date == null
                            ? "Selecione a data"
                            : "${date.day}/${date.month}/${date.year}",
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // -------------------- HORÁRIO --------------------
              ValueListenableBuilder<TimeOfDay?>(
                valueListenable: vm.meetingTime,
                builder: (_, time, __) {
                  return InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: time ?? TimeOfDay.now(),
                      );
                      if (picked != null) vm.meetingTime.value = picked;
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Horário",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        time == null
                            ? "Selecione o horário"
                            : "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // -------------------- PONTO DE ENCONTRO --------------------
              TextFormField(
                controller: vm.meetingPointController,
                decoration: const InputDecoration(
                  labelText: "Ponto de Encontro",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? "Digite o ponto de encontro"
                    : null,
                onSaved: (value) {
                  if (value != null) {
                    vm.meetingPoint.value = value;
                  }
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
