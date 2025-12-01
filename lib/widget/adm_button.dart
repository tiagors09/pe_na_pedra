import 'package:flutter/material.dart';

class AdmButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AdmButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // remove background
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ), // outline preta
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          16,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Center(
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min, // evita estourar o espaço
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.black,
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // segurança
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
