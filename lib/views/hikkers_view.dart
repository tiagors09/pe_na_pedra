import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/dialog_launcher.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/viewmodel/hikkers_viewmodel.dart';
import 'package:pe_na_pedra/widget/hikker_list.dart';

class HikkersView extends StatefulWidget {
  const HikkersView({super.key});

  @override
  State<HikkersView> createState() => _HikkersViewState();
}

class _HikkersViewState extends State<HikkersView> {
  late HikkersViewmodel _viewModel;
  late GlobalState globalState;

  @override
  void initState() {
    _viewModel = HikkersViewmodel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    globalState = GlobalStateProvider.of(context);

    _viewModel.role = globalState.profile?['role'] ?? UserRoles.hikker.name;

    _viewModel.fetchOnce(globalState.idToken!);
  }

  @override
  Widget build(BuildContext context) {
    final loggedUserId = globalState.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trilheiros'),
      ),
      body: ValueListenableBuilder<List<Hikker>>(
        valueListenable: _viewModel.hikkers,
        builder: (context, hikkers, _) {
          if (!_viewModel.initialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final adms = hikkers.where((h) => h.role == UserRoles.adm).toList();
          final users = hikkers.where((h) => h.role != UserRoles.adm).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar trilheiro...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => _viewModel.setSearchQuery(
                    value,
                    loggedUserId!,
                  ),
                ),
              ),
              Expanded(
                child: HikkerList(
                  adms: adms,
                  users: users,
                  loggedUserId: loggedUserId,
                  onSwipe: (hikker, direction) async {
                    final action =
                        await _viewModel.handleSwipe(direction, hikker);

                    if (action == SwipeAction.none) return false;

                    final confirm = await DialogLauncher.showConfirmDialog(
                      context,
                      title: _viewModel.titleFor(action, hikker),
                      message: _viewModel.messageFor(action, hikker),
                      confirmText: _viewModel.btnFor(action),
                    );

                    if (!confirm) return false;

                    await _viewModel.executeAction(action, hikker);
                    return true;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
