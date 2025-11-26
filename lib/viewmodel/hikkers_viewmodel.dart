import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/hikkers_controllers.dart';
import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/enums.dart';

class HikkersViewmodel with ChangeNotifier {
  final _controller = HikkersControllers();

  String role = UserRoles.hikker.name;

  int currentIndex = 0;

  bool get isAdmin => role == UserRoles.adm.name;

  Future<List<Hikker>> fetchOnce(GlobalState globalState) {
    return _controller.fetchHikkers(idToken: globalState.idToken);
  }
}
