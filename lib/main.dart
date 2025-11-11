import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:pe_na_pedra/app.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  usePathUrlStrategy();

  runApp(
    GlobalStateProvider(
      notifier: GlobalState(),
      child: const App(),
    ),
  );
}
