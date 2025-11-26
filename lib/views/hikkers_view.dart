import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/enums.dart';
import 'package:pe_na_pedra/viewmodel/hikkers_viewmodel.dart';

class HikkersView extends StatefulWidget {
  const HikkersView({super.key});

  @override
  State<HikkersView> createState() => _HikkersViewState();
}

class _HikkersViewState extends State<HikkersView> {
  late HikkersViewmodel _viewModel;
  late GlobalState globalState;

  @override
  void initState() {
    _viewModel = HikkersViewmodel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    globalState = GlobalStateProvider.of(context);

    final String role = globalState.profile?['role'] ?? UserRoles.hikker.name;
    _viewModel.role = role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trilheiros'),
        actions: const [],
      ),
      body: FutureBuilder(
        future: _viewModel.fetchOnce(globalState),
        builder: (ctx, snp) {
          return const Text('snp.data');
        },
      ),
    );
  }
}
