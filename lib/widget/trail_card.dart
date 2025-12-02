import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/model/trail.dart';
import 'package:pe_na_pedra/widget/difficulty_chip.dart';

class TrailCard extends StatelessWidget {
  final Trail trail;
  final VoidCallback? onViewDetailTrail;

  const TrailCard({
    super.key,
    required this.trail,
    this.onViewDetailTrail,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat(
      'dd/MM/yyyy',
    ).format(
      trail.meetingDate,
    );

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    trail.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DifficultyChip(
                  diff: trail.difficulty,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Text(
                    dateFormatted,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 18,
                ),
                Text(
                  trail.meetingTime,
                ),
              ],
            ),
            if (trail.meetingAddress != null &&
                trail.meetingAddress!.isNotEmpty)
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.place,
                    size: 18,
                  ),
                  Expanded(
                    child: Text(
                      trail.meetingAddress!,
                    ),
                  ),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Icon(
                  Icons.people,
                  size: 18,
                ),
                Text(
                  "Vagas: ${trail.spots}",
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewDetailTrail,
                child: const Text(
                  "Ver detalhes",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
