// lib/controllers/routes_controller.dart
import 'dart:async';
import 'package:pe_na_pedra/model/trail_route.dart';
import 'package:pe_na_pedra/services/firebase_rest_service.dart';

class RoutesController {
  final FirebaseRestService _db = FirebaseRestService.instance;

  /// Cria uma nova rota (push auto-id)
  Future<void> createRoute(TrailRoute route, {required String? idToken}) async {
    await _db.post('routes', route.toMap(), auth: idToken);
  }

  /// Atualiza uma rota existente pelo ID
  Future<void> updateRoute(String id, TrailRoute route, {required String? idToken}) async {
    await _db.put('routes/$id', route.toMap(), auth: idToken);
  }

  /// Remove uma rota pelo ID
  Future<void> deleteRoute(String id, {required String? idToken}) async {
    await _db.delete('routes/$id', auth: idToken);
  }

  /// Busca todas as rotas do Firebase
  Future<List<TrailRoute>> fetchRoutes({required String? idToken}) async {
    final data = await _db.get('routes', auth: idToken);
    if (data == null) return [];

    // 🔥 Caso venha LISTA
    if (data is List) {
      return data
          .asMap()
          .entries
          .where((e) => e.value != null)
          .map((e) => TrailRoute.fromMap(Map<String, dynamic>.from(e.value)))
          .toList();
    }

    // 🔥 Caso venha MAP (formato ideal do Firebase)
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      return map.entries
          .where((e) => e.value != null)
          .map((e) => TrailRoute.fromMap(Map<String, dynamic>.from(e.value)))
          .toList();
    }

    throw Exception("Formato inesperado em /routes: ${data.runtimeType}");
  }
}
