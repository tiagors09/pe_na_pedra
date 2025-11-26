// lib/viewmodel/trails_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/trails_controller.dart';
import 'package:pe_na_pedra/model/trail.dart';

import 'package:pe_na_pedra/provider/global_state.dart';

class TrailsViewModel extends ChangeNotifier {
  final TrailsController _controller = TrailsController();

  Future<List<Trail>> fetchOnce(GlobalState globalState) {
    return _controller.fetchTrails(idToken: globalState.idToken);
  }

  Future<String> createTrail(Trail t, GlobalState globalState) {
    return _controller.createTrail(t, idToken: globalState.idToken);
  }

  Future<void> updateTrail(String id, Trail t, GlobalState globalState) {
    return _controller.updateTrail(id, t, idToken: globalState.idToken);
  }

  Future<void> deleteTrail(String id, GlobalState globalState) {
    return _controller.deleteTrail(id, idToken: globalState.idToken);
  }
}
