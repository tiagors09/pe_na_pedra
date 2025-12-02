// lib/services/auth_cache_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCacheService {
  static const _keyProfile = 'profileCache';

  // SALVA PERFIL COMPLETO
  static Future<void> saveProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyProfile, jsonEncode(profile));
  }

  // CARREGA PERFIL DO CACHE
  static Future<Map<String, dynamic>?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyProfile);
    if (json == null) return null;
    return jsonDecode(json);
  }

  // LIMPA PERFIL
  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyProfile);
  }

  // SALVA TOKENS E USERID
  static Future<void> saveSession({
    required String userId,
    required String idToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
    prefs.setString("idToken", idToken);
    prefs.setString("refreshToken", refreshToken);
  }

  static Future<Map<String, String?>> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "userId": prefs.getString("userId"),
      "idToken": prefs.getString("idToken"),
      "refreshToken": prefs.getString("refreshToken"),
    };
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("idToken");
    prefs.remove("refreshToken");
  }
}
