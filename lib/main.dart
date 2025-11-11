import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:pe_na_pedra/app.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/configuration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    log(
      'Inicializando Supabase...',
      name: 'Main',
    );
    await Supabase.initialize(
      url: Configuration.supabaseUrl,
      anonKey: Configuration.supabaseKey,
    );
    log(
      'Supabase inicializado com sucesso!',
      name: 'Main',
    );
  } catch (e, st) {
    log(
      'Erro ao inicializar Supabase: $e',
      stackTrace: st,
      name: 'Main',
    );
  }

  usePathUrlStrategy();

  runApp(
    GlobalStateProvider(
      notifier: GlobalState(),
      child: const App(),
    ),
  );
}
