import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/trail.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/trails_viewmodel.dart';
import 'package:pe_na_pedra/widget/trail_card.dart';

class TrailsView extends StatefulWidget {
  const TrailsView({super.key});

  @override
  State<TrailsView> createState() => _TrailsViewState();
}

class _TrailsViewState extends State<TrailsView> {
  late Future<List<Trail>> _future;

  final TrailsViewModel _vm = TrailsViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final global = GlobalStateProvider.of(context);
    _future = _vm.fetchOnce(global);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trail>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erro ao carregar trilhas:\n${snapshot.error}",
              textAlign: TextAlign.center,
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
          itemBuilder: (_, i) => TrailCard(
            trail: trails[i],
          ),
        );
      },
    );
  }
}
