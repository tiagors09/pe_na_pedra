import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pe_na_pedra/model/route_point.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/viewmodel/route_form_viewmodel.dart';
import 'package:pe_na_pedra/widget/route_info.dart';

class RouteFormView extends StatefulWidget {
  const RouteFormView({super.key});

  @override
  State<RouteFormView> createState() => _RouteFormViewState();
}

class _RouteFormViewState extends State<RouteFormView> {
  late final RouteFormViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = RouteFormViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Trilha'),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.055,
          margin: const EdgeInsets.all(
            16,
          ),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _vm.save,
            child: const Text(
              'Salvar',
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Form(
            key: GlobalKey<FormState>(),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _vm.name.value,
                  decoration: const InputDecoration(
                    labelText: 'Nome da trilha',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _vm.setName,
                ),
                DropdownButtonFormField<Difficulty>(
                  decoration: const InputDecoration(
                    labelText: 'Dificuldade',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _vm.difficulty.value,
                  items: _vm.difficulties,
                  onChanged: _vm.onDifficultyChange,
                ),
                ValueListenableBuilder<List<RoutePoint>>(
                  valueListenable: _vm.points,
                  builder: (_, points, __) {
                    if (points.isEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            if (_vm.canTrackRoute()) {
                              final result =
                                  await Navigator.of(context).pushNamed(
                                AppRoutes.trackRoute,
                              );

                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                final points = result['points'] as List<LatLng>;
                                final distance = result['distanceKm'] as double;
                                final speed = result['speedKmh'] as double;
                                final elapsed =
                                    result['elapsedTime'] as Duration;

                                // Salvar no Firebase
                                log(
                                  'Distância: $distance km, Velocidade: $speed km/h, Elapsed time: $elapsed',
                                  name: 'RouteFormView',
                                );
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.map,
                          ),
                          label: const Text(
                            'Gravar rota',
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: RouteInfo(
                        points: points,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
