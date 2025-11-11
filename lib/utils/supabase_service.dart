import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pe_na_pedra/utils/configuration.dart';

class SupabaseService {
  SupabaseService._(); // construtor privado

  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  late final SupabaseClient client;

  /// Inicializa o Supabase uma única vez (geralmente chamada em main()).
  static Future<void> init() async {
    try {
      log('Inicializando Supabase...', name: 'SupabaseService');
      await Supabase.initialize(
        url: Configuration.supabaseUrl,
        anonKey: Configuration.supabaseKey,
      );
      _instance.client = Supabase.instance.client;
      log('Supabase inicializado com sucesso!', name: 'SupabaseService');
    } catch (e, st) {
      log('Erro ao inicializar Supabase: $e',
          stackTrace: st, name: 'SupabaseService');
      rethrow;
    }
  }
}
