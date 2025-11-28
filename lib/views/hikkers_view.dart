import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/viewmodel/hikkers_viewmodel.dart';

class HikkersView extends StatefulWidget {
  const HikkersView({super.key});

  @override
  State<HikkersView> createState() => _HikkersViewState();
}

class _HikkersViewState extends State<HikkersView> {
  late HikkersViewmodel _viewModel;
  late GlobalState globalState;

  String query = "";

  @override
  void initState() {
    _viewModel = HikkersViewmodel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    globalState = GlobalStateProvider.of(context);

    final String role = globalState.profile?['role'] ?? UserRoles.hikker.name;
    _viewModel.role = role;
  }

  @override
  Widget build(BuildContext context) {
    final loggedUserId = globalState.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trilheiros'),
      ),
      body: FutureBuilder(
        future: _viewModel.fetchOnce(globalState),
        builder: (ctx, snp) {
          if (snp.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snp.hasError) {
            return const Center(
              child: Text('Erro ao obter lista de trilheiros'),
            );
          }

          List hikkers = snp.data ?? [];

          if (hikkers.isEmpty) {
            return const Center(child: Text('Nenhum trilheiro cadastrado'));
          }

          // Filtra pela busca
          if (query.isNotEmpty) {
            hikkers = hikkers
                .where((h) =>
                    h.fullName.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }

          // ------------ ORDENAR LISTA ------------
          hikkers.sort((a, b) {
            if (a.id == loggedUserId) return -1;
            if (b.id == loggedUserId) return 1;

            if (a.role == UserRoles.adm && b.role != UserRoles.adm) return -1;
            if (b.role == UserRoles.adm && a.role != UserRoles.adm) return 1;

            return a.fullName.compareTo(b.fullName);
          });

          // ------------ SEPARAR POR GRUPOS ------------
          final adms = hikkers.where((h) => h.role == UserRoles.adm).toList();
          final users = hikkers.where((h) => h.role != UserRoles.adm).toList();

          return Column(
            children: [
              // ---------------- BUSCA ----------------
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
                  onChanged: (value) {
                    setState(() => query = value);
                  },
                ),
              ),

              // ---------------- LISTA ----------------
              Expanded(
                child: ListView(
                  children: [
                    // ---------- HEADER ADM ----------
                    if (adms.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          "Administradores",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                    ...adms.map(
                      (hikker) => _buildHikkerTile(
                        context,
                        hikker,
                        loggedUserId,
                        isAdminSection: true,
                      ),
                    ),

                    // ---------- HEADER TRILHEIROS ----------
                    if (users.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          "Trilheiros",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                    ...users.map(
                      (hikker) => _buildHikkerTile(
                        context,
                        hikker,
                        loggedUserId,
                        isAdminSection: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ====================================================
  //               BUILDER DO TILE COM SWIPE
  // ====================================================
  Widget _buildHikkerTile(
    BuildContext context,
    hikker,
    String? loggedId, {
    required bool isAdminSection,
  }) {
    final bool isLogged = hikker.id == loggedId;
    final bool isAdmin = hikker.role == UserRoles.adm;

    return Dismissible(
      key: ValueKey(hikker.id),
      direction: isLogged ? DismissDirection.none : DismissDirection.horizontal,
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.block, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (isLogged) return Future.value(false);

        if (direction == DismissDirection.startToEnd) {
          await _viewModel.promoteToAdmin(hikker.id);
        } else {
          await _viewModel.banUser(hikker.id);
        }

        setState(() {});
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          color: isLogged ? Colors.blue.withAlpha(15) : null,
          border: isLogged
              ? Border(
                  left: BorderSide(
                    width: 4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/avatar_placeholder_large.png',
            ),
            radius: 24,
          ),
          title: Text(
            hikker.fullName,
            style: TextStyle(
                fontWeight: isLogged ? FontWeight.bold : FontWeight.normal),
          ),
          subtitle: Text(hikker.address),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAdmin ? Icons.star : Icons.person,
                color: isAdmin ? Colors.orange : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                isAdmin ? "ADM" : "TRILHEIRO",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isAdmin ? Colors.orange : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
