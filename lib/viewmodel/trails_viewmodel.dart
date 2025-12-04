// lib/viewmodel/trails_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/trails_controller.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';

import 'package:pe_na_pedra/provider/global_state.dart';

class TrailsViewModel extends ChangeNotifier {
  final TrailsController _controller = TrailsController();

  Future<List<ScheduledTrail>> fetchOnce(GlobalState globalState) {
    return _controller.fetchTrails(idToken: globalState.idToken);
  }
}
