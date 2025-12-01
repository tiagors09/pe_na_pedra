import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/hikkers_controllers.dart';
import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class HikkersViewmodel with ChangeNotifier {
  final _controller = HikkersControllers();

  String role = UserRoles.hikker.name;
  bool get isAdmin => role == UserRoles.adm.name;

  final ValueNotifier<bool> loading = ValueNotifier(false);

  // lista completa (não filtrada)
  List<Hikker> _allHikkers = [];

  // pesquisa
  final ValueNotifier<String> searchQuery = ValueNotifier("");

  // lista filtrada + ordenada
  final ValueNotifier<List<Hikker>> hikkers = ValueNotifier([]);

  bool _initialized = false;
  bool get initialized => _initialized;

  Future<void> fetchOnce(String idToken) async {
    if (_initialized) return;

    _allHikkers = await _controller.fetchHikkers(idToken: idToken);
    _initialized = true;

    _applyFiltersAndSort();
  }

  // ======================================================
  //   FILTRAR + ORDENAR
  // ======================================================
  void _applyFiltersAndSort({String? loggedUserId}) {
    var list = [..._allHikkers];

    // --- busca ---
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list =
          list.where((h) => h.fullName.toLowerCase().contains(query)).toList();
    }

    // --- ordenação (INDO PARA VM COMO PEDIDO) ---
    if (loggedUserId != null) {
      list.sort((a, b) {
        if (a.id == loggedUserId) return -1;
        if (b.id == loggedUserId) return 1;

        if (a.role == UserRoles.adm && b.role != UserRoles.adm) return -1;
        if (b.role == UserRoles.adm && a.role != UserRoles.adm) return 1;

        return a.fullName.compareTo(b.fullName);
      });
    }

    hikkers.value = list;
  }

  // ======================================================
  // PESQUISA (CHAMADO PELA VIEW)
  // ======================================================
  void setSearchQuery(String value, String loggedUserId) {
    searchQuery.value = value;

    _applyFiltersAndSort(
      loggedUserId: loggedUserId,
    );
  }

  // ======================================================
  // SWIPE LOGIC (SEM MUDANÇAS)
  // ======================================================
  Future<SwipeAction> handleSwipe(DismissDirection direction, Hikker h) async {
    final bool isAdmin = h.role == UserRoles.adm;
    final bool isBanned = h.role == UserRoles.banned;

    if (direction == DismissDirection.startToEnd) {
      return isBanned ? SwipeAction.unban : SwipeAction.ban;
    }

    if (direction == DismissDirection.endToStart) {
      return isAdmin ? SwipeAction.removeAdmin : SwipeAction.makeAdmin;
    }

    return SwipeAction.none;
  }

  // ======================================================
  // EXECUTAR AÇÃO E ATUALIZAR LISTA LOCAL
  // ======================================================
  Future<void> executeAction(SwipeAction action, Hikker h) async {
    loading.value = true;

    switch (action) {
      case SwipeAction.ban:
        await banUser(h.id);
        break;
      case SwipeAction.unban:
        await unbanUser(h.id);
        break;
      case SwipeAction.makeAdmin:
        await promoteToAdmin(h.id);
        break;
      case SwipeAction.removeAdmin:
        await demoteAdmin(h.id);
        break;
      default:
        break;
    }

    loading.value = false;

    // UPDATE LOCAL
    final index = _allHikkers.indexWhere((x) => x.id == h.id);
    if (index != -1) {
      _allHikkers[index] = _allHikkers[index].copyWith(
        role: _roleForAction(action),
      );
    }

    _applyFiltersAndSort();
  }

  UserRoles _roleForAction(SwipeAction action) {
    switch (action) {
      case SwipeAction.ban:
        return UserRoles.banned;
      case SwipeAction.unban:
        return UserRoles.hikker;
      case SwipeAction.makeAdmin:
        return UserRoles.adm;
      case SwipeAction.removeAdmin:
        return UserRoles.hikker;
      default:
        return UserRoles.hikker;
    }
  }

  // CONTROLLERS (sem mudanças)
  Future<void> promoteToAdmin(String uid) async => await _controller.updateRole(
        uid: uid,
        newRole: UserRoles.adm.name,
      );

  Future<void> demoteAdmin(String uid) async => await _controller.updateRole(
        uid: uid,
        newRole: UserRoles.hikker.name,
      );

  Future<void> banUser(String uid) async => await _controller.updateRole(
        uid: uid,
        newRole: UserRoles.banned.name,
      );

  Future<void> unbanUser(String uid) async => await _controller.updateRole(
        uid: uid,
        newRole: UserRoles.hikker.name,
      );

  String titleFor(SwipeAction a, Hikker h) {
    switch (a) {
      case SwipeAction.ban:
        return "Banir usuário";
      case SwipeAction.unban:
        return "Desbanir usuário";
      case SwipeAction.makeAdmin:
        return "Promover para ADM";
      case SwipeAction.removeAdmin:
        return "Remover ADM";
      default:
        return "";
    }
  }

  String messageFor(SwipeAction a, Hikker h) {
    switch (a) {
      case SwipeAction.ban:
        return "Deseja banir ${h.fullName}?";
      case SwipeAction.unban:
        return "Deseja desbanir ${h.fullName}?";
      case SwipeAction.makeAdmin:
        return "Deseja promover ${h.fullName} a administrador?";
      case SwipeAction.removeAdmin:
        return "Deseja remover privilégio de ADM de ${h.fullName}?";
      default:
        return "";
    }
  }

  String btnFor(SwipeAction a) {
    switch (a) {
      case SwipeAction.ban:
        return "Banir";
      case SwipeAction.unban:
        return "Desbanir";
      case SwipeAction.makeAdmin:
        return "Promover";
      case SwipeAction.removeAdmin:
        return "Remover";
      default:
        return "";
    }
  }
}
