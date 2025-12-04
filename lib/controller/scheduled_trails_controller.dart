// lib/controllers/scheduled_trails_controller.dart
import 'dart:async';
import 'dart:developer';
import 'package:pe_na_pedra/model/scheduled_trail.dart';
import 'package:pe_na_pedra/services/firebase_rest_service.dart';

class ScheduledTrailsController {
  final FirebaseRestService _db = FirebaseRestService.instance;

  /// Cria uma trilha agendada (push auto-id)
  Future<void> createScheduledTrail(
    ScheduledTrail trail, {
    required String? idToken,
  }) async {
    await _db.post('scheduled_trails', trail.toMap(), auth: idToken);
  }

  /// Atualiza uma trilha existente
  Future<void> updateScheduledTrail(
    String id,
    ScheduledTrail trail, {
    required String? idToken,
  }) async {
    await _db.put('scheduled_trails/$id', trail.toMap(), auth: idToken);
  }

  /// Remove uma trilha pelo ID
  Future<void> deleteScheduledTrail(
    String id, {
    required String? idToken,
  }) async {
    await _db.delete('scheduled_trails/$id', auth: idToken);
  }

  /// Busca TUDO de /scheduled_trails e converte para model
  Future<List<ScheduledTrail>> fetchScheduledTrails({
    required String? idToken,
    bool autoCleanExpired = true,
  }) async {
    log("Buscando trilhas agendadas...", name: 'ScheduledTrailsController');

    final data = await _db.get('scheduled_trails', auth: idToken);

    log("RAW Firebase response: $data", name: 'ScheduledTrailsController');

    if (data == null) {
      log("Nenhum dado retornado", name: 'ScheduledTrailsController');
      return [];
    }

    if (data is! Map) {
      log("Formato inesperado (não é MAP): ${data.runtimeType}",
          name: 'ScheduledTrailsController');
      return [];
    }

    final map = Map<String, dynamic>.from(data);
    final List<ScheduledTrail> result = [];

    log("Convertendo nós do Firebase...", name: 'ScheduledTrailsController');

    for (final e in map.entries) {
      log("Processando ID: ${e.key}", name: 'ScheduledTrailsController');

      if (e.value == null) {
        log("Ignorado (valor null)", name: 'ScheduledTrailsController');
        continue;
      }

      final trail = ScheduledTrail.fromMap(
        Map<String, dynamic>.from(e.value),
        id: e.key,
      );

      log("Trilha carregada: ${trail.toMap()}",
          name: 'ScheduledTrailsController');

      result.add(trail);
    }

    log("Total carregado: ${result.length}", name: 'ScheduledTrailsController');

    if (autoCleanExpired && result.isNotEmpty) {
      log("Limpando trilhas expiradas...", name: 'ScheduledTrailsController');
      await _cleanExpired(result, idToken);
    }

    return result;
  }

  /// Remove trilhas com data < hoje
  Future<void> _cleanExpired(
    List<ScheduledTrail> all,
    String? idToken,
  ) async {
    final now = DateTime.now();

    final expired = all.where((t) => t.meetingDate.isBefore(now)).toList();

    for (final t in expired) {
      await deleteScheduledTrail(t.id!, idToken: idToken);
    }
  }
}
