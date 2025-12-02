import 'package:flutter/material.dart';
import 'hikker_list_item.dart';

class HikkerList extends StatelessWidget {
  final List adms;
  final List users;
  final String? loggedUserId;
  final Future<bool> Function(dynamic hikker, DismissDirection direction)
      onSwipe;

  const HikkerList({
    super.key,
    required this.adms,
    required this.users,
    required this.loggedUserId,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (adms.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              "Administradores",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ...adms.map(
          (h) => HikkerListItem(
            hikker: h,
            loggedUserId: loggedUserId,
            onSwipe: (dir) => onSwipe(
              h,
              dir,
            ),
          ),
        ),
        if (users.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              "Trilheiros",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ...users.map(
          (h) => HikkerListItem(
            hikker: h,
            loggedUserId: loggedUserId,
            onSwipe: (dir) => onSwipe(
              h,
              dir,
            ),
          ),
        ),
      ],
    );
  }
}
