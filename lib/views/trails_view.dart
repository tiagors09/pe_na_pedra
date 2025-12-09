import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/trails_viewmodel.dart';
import 'package:pe_na_pedra/widget/trail_card.dart';

class TrailsView extends StatefulWidget {
  const TrailsView({super.key});

  @override
  State<TrailsView> createState() => _TrailsViewState();
}

class _TrailsViewState extends State<TrailsView> {
  late Future<List<ScheduledTrail>> _future;

  final TrailsViewModel _vm = TrailsViewModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final global = GlobalStateProvider.of(context);
    _future = _vm.fetchOnce(global);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScheduledTrail>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Erro ao carregar trilhas",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        final global = GlobalStateProvider.of(context);
                        _future = _vm.fetchOnce(global);
                      },
                    );
                  },
                  child: const Text("Tentar novamente"),
                ),
              ],
            ),
          );
        }

        final trails = snapshot.data ?? [];

        if (trails.isEmpty) {
          return const Center(
            child: Text("Nenhuma trilha cadastrada."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trails.length,
          itemBuilder: (_, i) {
            final trail = trails[i];
            final global = GlobalStateProvider.of(context);

            final String userId = global.isLoggedIn ? global.userId! : "";

            return TrailCard(
              trail: trail,
              currentUserId: userId,

              // Só ativa callbacks se o usuário estiver logado
              onSubscribe: global.isLoggedIn
                  ? (t) async {
                      await _vm.subscribe(global, t);
                      setState(() {});
                    }
                  : null,

              onUnsubscribe: global.isLoggedIn
                  ? (t) async {
                      await _vm.unsubscribe(global, t);
                      setState(() {});
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}
