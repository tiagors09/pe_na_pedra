import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/hikkers_controllers.dart';
import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class HikkersViewmodel with ChangeNotifier {
  final _controller = HikkersControllers();

  String role = UserRoles.hikker.name;
  bool get isAdmin => role == UserRoles.adm.name;

  // ======================================================
  //           BUSCA APENAS UMA VEZ NO FIREBASE
  // ======================================================
  Future<List<Hikker>> fetchOnce(GlobalState globalState) async {
    return _controller.fetchHikkers(idToken: globalState.idToken);
  }

  // ======================================================
  //            PROMOVER PARA ADMIN
  // ======================================================
  Future<void> promoteToAdmin(String uid) async {
    /*
    await _controller.updateRole(
      idToken: globalState.idToken,
      uid: uid,
      newRole: UserRoles.adm.name,
    ); */
  }

  // ======================================================
  //           BANIR / REMOVER USUÁRIO
  // ======================================================
  Future<void> banUser(String uid) async {
    /*
    await _controller.deleteHikker(
      idToken: globalState.idToken,
      uid: uid,
    );*/
  }
}
