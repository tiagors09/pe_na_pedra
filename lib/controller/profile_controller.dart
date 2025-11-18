// lib/controllers/profile_controller.dart
import 'package:pe_na_pedra/services/firebase_rest_service.dart';

class ProfileController {
  final FirebaseRestService _db = FirebaseRestService.instance;

  Future<Map<String, dynamic>?> fetchProfile(
      String userId, String? authToken) async {
    final data = await _db.get('profiles/$userId', auth: authToken);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<void> upsertProfile(
      String userId, Map<String, dynamic> payload, String? authToken) async {
    await _db.put('profiles/$userId', payload, auth: authToken);
  }
}
