import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/hikkers_controllers.dart';
import 'package:pe_na_pedra/controller/scheduled_trails_controller.dart';
import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';

class TrailSubscribersViewmodel {
  final ScheduledTrailsController scheduledCtrl = ScheduledTrailsController();
  final HikkersControllers hikkersCtrl = HikkersControllers();

  late String idToken;
  late ScheduledTrail trail;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Listas finais separadas
  ValueNotifier<List<Hikker>> admins = ValueNotifier([]);
  ValueNotifier<List<Hikker>> users = ValueNotifier([]);

  /// Carrega os inscritos + dados dos hikkers
  Future<void> load() async {
    isLoading.value = true;

    final subsIds = trail.subscribers ?? [];

    // pega todos hikkers do sistema
    final all = await hikkersCtrl.fetchHikkers(idToken: idToken);

    final subs = all.where((h) => subsIds.contains(h.id)).toList();

    final adms = <Hikker>[];
    final usr = <Hikker>[];

    for (final h in subs) {
      if (h.role == "admin") {
        adms.add(h);
      } else {
        usr.add(h);
      }
    }

    admins.value = adms;
    users.value = usr;

    isLoading.value = false;
  }

  /// Remove um inscrito
  Future<void> removeSubscriber(String uid) async {
    await scheduledCtrl.unsubscribeFromTrail(
      idToken: idToken,
      userId: uid,
      trailId: trail.id!,
    );

    await load();
  }
}
