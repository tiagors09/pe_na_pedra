import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class HikkerListItem extends StatelessWidget {
  final dynamic hikker;
  final String? loggedUserId;
  final Future<bool> Function(DismissDirection direction) onSwipe;

  const HikkerListItem({
    super.key,
    required this.hikker,
    required this.loggedUserId,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLogged = hikker.id == loggedUserId;
    final bool isAdmin = hikker.role == UserRoles.adm;
    final bool isBanned = hikker.role == UserRoles.banned;

    final bool allowLeft = !isLogged;
    final bool allowRight = !isLogged && !isBanned;

    return Dismissible(
      key: ValueKey(hikker.id),
      direction: allowLeft && allowRight
          ? DismissDirection.horizontal
          : allowLeft
              ? DismissDirection.startToEnd
              : allowRight
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
      background: allowLeft
          ? Container(
              color: isBanned ? Colors.green : Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: Icon(
                isBanned ? Icons.undo : Icons.block,
                color: Colors.white,
              ),
            )
          : null,
      secondaryBackground: allowRight
          ? Container(
              color: isAdmin ? Colors.orange : Colors.blue,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                isAdmin ? Icons.remove_moderator : Icons.arrow_upward,
                color: Colors.white,
              ),
            )
          : null,
      confirmDismiss: onSwipe,
      child: Container(
        decoration: BoxDecoration(
          color: isLogged ? Colors.blue.withAlpha(30) : null,
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
            backgroundImage:
                AssetImage('assets/images/avatar_placeholder_large.png'),
            radius: 24,
          ),
          title: Text(
            hikker.fullName,
            style: TextStyle(
              fontWeight: isLogged ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(hikker.address),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isBanned
                    ? Icons.block
                    : isAdmin
                        ? Icons.star
                        : Icons.person,
                color: isBanned
                    ? Colors.red
                    : isAdmin
                        ? Colors.orange
                        : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                isBanned
                    ? "BANIDO"
                    : isAdmin
                        ? "ADM"
                        : "TRILHEIRO",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isBanned
                      ? Colors.red
                      : isAdmin
                          ? Colors.orange
                          : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
