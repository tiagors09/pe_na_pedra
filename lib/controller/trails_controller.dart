// lib/controllers/trails_controller.dart
import 'dart:async';
import 'package:pe_na_pedra/model/trail.dart';
import 'package:pe_na_pedra/services/firebase_rest_service.dart';

class TrailsController {
  final FirebaseRestService _db = FirebaseRestService.instance;

  /// Create trail (push auto-id)
  Future<String> createTrail(Trail trail, {required String? idToken}) async {
    final res = await _db.post('trails', trail.toMap(), auth: idToken);
    // Firebase returns { "name": "-MQxxx" }
    return res['name'] as String;
  }

  Future<void> updateTrail(String id, Trail trail,
      {required String? idToken}) async {
    await _db.put('trails/$id', trail.toMap(), auth: idToken);
  }

  Future<void> deleteTrail(String id, {required String? idToken}) async {
    await _db.delete('trails/$id', auth: idToken);
  }

  Future<List<Trail>> fetchTrails({required String? idToken}) async {
    final data = await _db.get('trails', auth: idToken);
    if (data == null) return [];

    // 🔥 Caso venha LISTA
    if (data is List) {
      return data
          .asMap()
          .entries
          .where((e) => e.value != null)
          .map((e) => Trail.fromMap(
                e.key.toString(), // usa índice como ID
                Map<String, dynamic>.from(e.value),
              ))
          .toList();
    }

    // 🔥 Caso venha MAP (formato ideal do Firebase)
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      return map.entries
          .where((e) => e.value != null)
          .map((e) => Trail.fromMap(
                e.key,
                Map<String, dynamic>.from(e.value),
              ))
          .toList();
    }

    throw Exception("Formato inesperado em /trails: ${data.runtimeType}");
  }
}
