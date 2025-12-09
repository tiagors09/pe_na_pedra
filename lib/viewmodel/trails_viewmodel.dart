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

  Future<void> subscribe(GlobalState global, ScheduledTrail trail) async {
    await _controller.subscribeToTrail(
      idToken: global.idToken,
      userId: global.userId!,
      trailId: trail.id!,
    );

    // reflete no model local também
    trail.subscribers.add(global.userId!);

    notifyListeners();
  }

  Future<void> unsubscribe(GlobalState global, ScheduledTrail trail) async {
    await _controller.unsubscribeFromTrail(
      idToken: global.idToken,
      userId: global.userId!,
      trailId: trail.id!,
    );

    trail.subscribers.remove(global.userId!);

    notifyListeners();
  }
}
