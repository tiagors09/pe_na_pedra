// lib/views/trails_view.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/model/trails.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/trails_viewmodel.dart';

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

    // Agora funciona: usa o contexto
    final global = GlobalStateProvider.of(context);

    _future = _vm.fetchOnce(global);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trilhas"),
      ),
      body: FutureBuilder<List<Trail>>(
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
            itemBuilder: (_, i) => _buildTrailCard(trails[i]),
          );
        },
      ),
    );
  }

  Widget _buildTrailCard(Trail t) {
    final dateFormatted = DateFormat('dd/MM/yyyy').format(t.meetingDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    t.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _difficultyChip(t.difficulty),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(dateFormatted),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 8),
                Text(t.meetingTime),
              ],
            ),
            const SizedBox(height: 12),
            if (t.meetingAddress != null && t.meetingAddress!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.place, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t.meetingAddress!)),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people, size: 18),
                const SizedBox(width: 8),
                Text("Vagas: ${t.spots}"),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Ver detalhes"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyChip(String diff) {
    Color color;
    String label;

    switch (diff) {
      case 'easy':
        color = Colors.green;
        label = "Fácil";
        break;
      case 'medium':
        color = Colors.orange;
        label = "Média";
        break;
      case 'hard':
        color = Colors.red;
        label = "Difícil";
        break;
      default:
        color = Colors.grey;
        label = diff;
    }

    return Chip(
      backgroundColor: color.withOpacity(0.15),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      shape: StadiumBorder(
        side: BorderSide(color: color.withOpacity(0.4)),
      ),
    );
  }
}
