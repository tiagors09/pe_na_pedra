import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pe_na_pedra/model/route_point.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/utils/form_validator.dart';
import 'package:pe_na_pedra/viewmodel/route_form_viewmodel.dart';
import 'package:pe_na_pedra/widget/route_info.dart';

class RouteFormView extends StatefulWidget {
  const RouteFormView({super.key});

  @override
  State<RouteFormView> createState() => _RouteFormViewState();
}

class _RouteFormViewState extends State<RouteFormView> with FormValidator {
  late final RouteFormViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = RouteFormViewModel();
  }

  void _onSave() {
    if (_vm.formKey.currentState?.validate() ?? false) {
      _vm.formKey.currentState?.save();
      _vm.save();
    }
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
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          child: ValueListenableBuilder<bool>(
            valueListenable: _vm.isSaving,
            builder: (_, loading, __) {
              return ElevatedButton(
                onPressed: loading ? null : _onSave,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _vm.name.value,
                  decoration: const InputDecoration(
                    labelText: 'Nome da trilha',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _vm.setName,
                  validator: validateNameField,
                  onSaved: (value) {
                    _vm.name.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Difficulty>(
                  decoration: const InputDecoration(
                    labelText: 'Dificuldade',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _vm.difficulty.value,
                  items: _vm.difficulties,
                  onChanged: _vm.onDifficultyChange,
                  validator: (value) =>
                      value == null ? 'Selecione a dificuldade' : null,
                  onSaved: (value) {
                    if (value != null) _vm.difficulty.value = value;
                  },
                ),
                const SizedBox(height: 16),
                FormField<List<RoutePoint>>(
                  initialValue: _vm.points.value,
                  validator: (_) {
                    if (_vm.points.value.isEmpty)
                      return 'Você deve gravar a rota';
                    return null;
                  },
                  builder: (state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Rota',
                        border: const OutlineInputBorder(),
                        errorText: state
                            .errorText, // aqui o texto de erro aparece igual ao TextFormField
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: ValueListenableBuilder<List<RoutePoint>>(
                        valueListenable: _vm.points,
                        builder: (_, pts, __) {
                          if (pts.isEmpty) {
                            return OutlinedButton.icon(
                              onPressed: () async {
                                if (_vm.canTrackRoute()) {
                                  final result = await Navigator.of(context)
                                      .pushNamed(AppRoutes.trackRoute);

                                  _vm.setRecordedRoute(
                                      result as Map<String, dynamic>?);
                                  state.validate();
                                }
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('Gravar rota'),
                            );
                          }
                          return SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: RouteInfo(
                              points: pts,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none,
                              ),
                            ),
                          );
                        },
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
