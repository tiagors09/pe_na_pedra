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
  late HikkersViewmodel _vm;
  late GlobalState global;

  @override
  void initState() {
    super.initState();
    _vm = HikkersViewmodel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    global = GlobalStateProvider.of(context);

    _vm.role = global.profile?['role'] ?? UserRoles.hikker.name;
    _vm.setLoggedUser(global.userId!);
    _vm.fetchOnce(global.idToken!);
  }

  @override
  Widget build(BuildContext context) {
    final loggedUserId = global.userId!;

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: _vm.showingBanned,
          builder: (_, banned, __) => Text(
            banned ? 'Banidos' : 'Trilheiros',
          ),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _vm.showingBanned,
            builder: (_, banned, __) {
              return IconButton(
                icon: Icon(banned ? Icons.group : Icons.block),
                tooltip: banned ? 'Ver trilheiros' : 'Ver banidos',
                onPressed: _vm.toggleList,
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Hikker>>(
        valueListenable: _vm.hikkers,
        builder: (_, list, __) {
          if (!_vm.initialized) {
            return const Center(child: CircularProgressIndicator());
          }

          // Separação das listas
          final banned = list.where((h) => h.role == UserRoles.banned).toList();
          final adms = list.where((h) => h.role == UserRoles.adm).toList();
          final users = list.where((h) => h.role == UserRoles.hikker).toList();

          final showingBanned = _vm.showingBanned.value;

          return Column(
            children: [
              // Campo de busca somente quando NÃO mostrando banidos
              if (!showingBanned)
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
                    onChanged: _vm.setSearchQuery,
                  ),
                ),

              Expanded(
                child: HikkerList(
                  adms: showingBanned ? const [] : adms,
                  users: showingBanned ? banned : users,
                  loggedUserId: loggedUserId,
                  onSwipe: (h, dir) async {
                    final action = await _vm.handleSwipe(dir, h);
                    if (action == SwipeAction.none) return false;

                    final confirm = await DialogLauncher.showConfirmDialog(
                      context,
                      title: _vm.titleFor(action, h),
                      message: _vm.messageFor(action, h),
                      confirmText: _vm.btnFor(action),
                    );

                    if (!confirm) return false;

                    await _vm.executeAction(action, h);
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
