import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/hikkers_controllers.dart';
import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class HikkersViewmodel {
  final _controller = HikkersControllers();

  String role = UserRoles.hikker.name;
  bool get isAdmin => role == UserRoles.adm.name;

  final ValueNotifier<bool> loading = ValueNotifier(false);

  // estados
  final ValueNotifier<bool> showingBanned = ValueNotifier(false);

  // dados brutos
  List<Hikker> _allHikkers = [];

  // pesquisa
  final ValueNotifier<String> searchQuery = ValueNotifier("");

  // lista filtrada + ordenada da view
  final ValueNotifier<List<Hikker>> hikkers = ValueNotifier([]);

  bool _initialized = false;
  bool get initialized => _initialized;

  String? _loggedUserId;

  // ----------------------------------------------------------
  // LOGGED USER
  // ----------------------------------------------------------
  void setLoggedUser(String uid) {
    _loggedUserId = uid;
  }

  // ----------------------------------------------------------
  // FETCH INICIAL
  // ----------------------------------------------------------
  Future<void> fetchOnce(String idToken) async {
    if (_initialized) return;

    _allHikkers = await _controller.fetchHikkers(idToken: idToken);
    _initialized = true;

    _applyFiltersAndSort();
  }

  // ----------------------------------------------------------
  // ALTERAR ENTRE TRILHEIROS / BANIDOS
  // ----------------------------------------------------------
  void toggleList() {
    showingBanned.value = !showingBanned.value;
    _applyFiltersAndSort();
  }

  // ----------------------------------------------------------
  // PESQUISA
  // ----------------------------------------------------------
  void setSearchQuery(String value) {
    searchQuery.value = value;
    _applyFiltersAndSort();
  }

  // ----------------------------------------------------------
  // FILTRAR + ORDENAR
  // ----------------------------------------------------------
  void _applyFiltersAndSort() {
    if (_loggedUserId == null) return;

    final query = searchQuery.value.trim().toLowerCase();

    List<Hikker> result;

    // BANIDOS ------------------------------------------------
    if (showingBanned.value) {
      result = _allHikkers.where((h) => h.role == UserRoles.banned).toList();

      if (query.isNotEmpty) {
        result = result.where((h) => h.fullName.toLowerCase().contains(query)).toList();
      }

      result.sort((a, b) => a.fullName.compareTo(b.fullName));
      hikkers.value = result;
      return;
    }

    // TRILHEIROS ---------------------------------------------
    result = _allHikkers.where((h) => h.role != UserRoles.banned).toList();

    if (query.isNotEmpty) {
      result = result.where((h) => h.fullName.toLowerCase().contains(query)).toList();
    }

    result.sort((a, b) {
      // logged user ADM no topo
      if (a.id == _loggedUserId) return -1;
      if (b.id == _loggedUserId) return 1;

      // ADMs depois
      final aAdm = a.role == UserRoles.adm;
      final bAdm = b.role == UserRoles.adm;

      if (aAdm && !bAdm) return -1;
      if (bAdm && !aAdm) return 1;

      // Ordem alfabética
      return a.fullName.compareTo(b.fullName);
    });

    hikkers.value = result;
  }

  // ----------------------------------------------------------
  // SWIPE LOGIC
  // ----------------------------------------------------------
  Future<SwipeAction> handleSwipe(DismissDirection direction, Hikker h) async {
    final isAdminUser = h.role == UserRoles.adm;
    final isBanned = h.role == UserRoles.banned;

    if (direction == DismissDirection.startToEnd) {
      return isBanned ? SwipeAction.unban : SwipeAction.ban;
    }

    if (direction == DismissDirection.endToStart) {
      return isAdminUser ? SwipeAction.removeAdmin : SwipeAction.makeAdmin;
    }

    return SwipeAction.none;
  }

  // ----------------------------------------------------------
  // EXECUTAR AÇÃO
  // ----------------------------------------------------------
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

  // CONTROLLERS
  Future<void> promoteToAdmin(String uid) async =>
      await _controller.updateRole(uid: uid, newRole: UserRoles.adm.name);

  Future<void> demoteAdmin(String uid) async =>
      await _controller.updateRole(uid: uid, newRole: UserRoles.hikker.name);

  Future<void> banUser(String uid) async =>
      await _controller.updateRole(uid: uid, newRole: UserRoles.banned.name);

  Future<void> unbanUser(String uid) async =>
      await _controller.updateRole(uid: uid, newRole: UserRoles.hikker.name);

  // TEXTOS
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
