import 'package:flutter/material.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/viewmodel/trail_subscribers_viewmodel.dart';

import 'package:pe_na_pedra/widget/hikker_list.dart';

class TrailSubscribersView extends StatefulWidget {
  const TrailSubscribersView({super.key});

  @override
  State<TrailSubscribersView> createState() => _TrailSubscribersViewState();
}

class _TrailSubscribersViewState extends State<TrailSubscribersView> {
  late final TrailSubscribersViewmodel vm;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    vm = TrailSubscribersViewmodel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      final global = GlobalStateProvider.of(context);

      vm.idToken = global.idToken!;
      vm.trail = ModalRoute.of(context)!.settings.arguments as ScheduledTrail;

      vm.load();
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedUserId = GlobalStateProvider.of(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscritos na trilha'),
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.isLoading,
        builder: (_, loading, __) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder(
            valueListenable: vm.admins,
            builder: (_, admins, __) {
              return ValueListenableBuilder(
                valueListenable: vm.users,
                builder: (_, users, __) {
                  final isEmpty = admins.isEmpty && users.isEmpty;

                  if (isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum trilheiro inscrito nesta trilha ainda.',
                      ),
                    );
                  }

                  return HikkerList(
                    adms: admins,
                    users: users,
                    loggedUserId: loggedUserId,
                    onSwipe: (hikker, direction) async {
                      await vm.removeSubscriber(hikker.id);
                      return true;
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
