import 'package:pe_na_pedra/model/hikker.dart';
import 'package:pe_na_pedra/services/firebase_rest_service.dart';

class HikkersControllers {
  final FirebaseRestService _db = FirebaseRestService.instance;

  Future<List<Hikker>> fetchHikkers({required String? idToken}) async {
    final data = await _db.get('profiles', auth: idToken);
    if (data == null) return [];

    // 🔥 Caso venha LISTA
    if (data is List) {
      return data
          .asMap()
          .entries
          .where((e) => e.value != null)
          .map(
            (e) => Hikker.fromMap(
              e.key.toString(), // usa índice como ID
              Map<String, dynamic>.from(e.value),
            ),
          )
          .toList();
    }

    // 🔥 Caso venha MAP (formato ideal do Firebase)
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      return map.entries
          .where((e) => e.value != null)
          .map(
            (e) => Hikker.fromMap(
              e.key,
              Map<String, dynamic>.from(e.value),
            ),
          )
          .toList();
    }

    throw Exception("Formato inesperado em /trails: ${data.runtimeType}");
  }
}
