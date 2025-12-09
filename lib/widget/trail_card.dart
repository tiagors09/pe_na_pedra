import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/dialog_launcher.dart';
import 'package:pe_na_pedra/widget/difficulty_chip.dart';

class TrailCard extends StatelessWidget {
  final ScheduledTrail trail;

  /// callback para inscrição
  final Future<void> Function(ScheduledTrail trail)? onSubscribe;

  /// callback para cancelar inscrição
  final Future<void> Function(ScheduledTrail trail)? onUnsubscribe;

  /// id do usuário atual
  final String currentUserId;

  const TrailCard({
    super.key,
    required this.trail,
    required this.currentUserId,
    this.onSubscribe,
    this.onUnsubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final route = trail.route;
    final dateFormatted = DateFormat('dd/MM/yyyy').format(trail.meetingDate);

    final bool isSubscribed = trail.subscribers.contains(currentUserId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome + dificuldade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    route?.name ?? "Rota não encontrada",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (route != null) DifficultyChip(diff: route.difficulty.name),
              ],
            ),

            // Data e hora
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Icon(Icons.calendar_today, size: 18),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Text(dateFormatted),
                ),
                const Icon(Icons.access_time, size: 18),
                Text(trail.meetingTime),
              ],
            ),

            // Ponto de encontro
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.place, size: 18),
                Expanded(child: Text(trail.meetingPoint)),
              ],
            ),

            // Botão detalhes
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.routeDetails,
                    arguments: route,
                  );
                },
                child: const Text("Ver detalhes"),
              ),
            ),

            // BOTÕES DE AÇÃO
            //
            // Só aparecem se o usuário estiver logado
            // E se os callbacks foram configurados
            if (currentUserId.isNotEmpty &&
                onSubscribe != null &&
                onUnsubscribe != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isSubscribed) {
                      final confirmed = await DialogLauncher.showConfirmDialog(
                        context,
                        title: "Cancelar inscrição",
                        message:
                            "Você deseja cancelar sua inscrição nesta trilha?",
                        confirmText: "Cancelar",
                      );

                      if (confirmed) {
                        await onUnsubscribe!(trail);
                      }
                    } else {
                      final confirmed = await DialogLauncher.showConfirmDialog(
                        context,
                        title: "Confirmar inscrição",
                        message: "Deseja se inscrever nesta trilha?",
                        confirmText: "Inscrever",
                      );

                      if (confirmed) {
                        await onSubscribe!(trail);
                      }
                    }
                  },
                  child: Text(
                    isSubscribed ? "Cancelar inscrição" : "Inscrever-se",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
