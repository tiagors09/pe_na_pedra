import 'package:flutter/material.dart';

class DifficultyChip extends StatelessWidget {
  final String diff;

  const DifficultyChip({
    super.key,
    required this.diff,
  });

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: color.withValues(alpha: 0.15),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      shape: StadiumBorder(
        side: BorderSide(color: color.withValues(alpha: 0.4)),
      ),
    );
  }
}
