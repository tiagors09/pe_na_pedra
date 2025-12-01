import 'package:flutter/material.dart';

class LoginProfileContentItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const LoginProfileContentItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 2),
                Text(
                  value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
