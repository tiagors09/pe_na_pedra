// lib/services/firebase_auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pe_na_pedra/services/firebase_rest_service.dart';

class FirebaseAuthService {
  FirebaseAuthService._();
  static final instance = FirebaseAuthService._();

  static const String _authBase = 'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String _tokenBase = 'https://securetoken.googleapis.com/v1/token';

  String get _apiKey => FirebaseRestService.apiKey;

  Future<Map<String, dynamic>> signUp({required String email, required String password}) async {
    final url = Uri.parse(
      '$_authBase:signUp?key=$_apiKey',
    );
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    return jsonDecode(
      res.body,
    );
  }

  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    final url = Uri.parse(
      '$_authBase:signInWithPassword?key=$_apiKey',
    );
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    return jsonDecode(
      res.body,
    );
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final url = Uri.parse('$_tokenBase?key=$_apiKey');
    final res = await http.post(
      url,
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );
    return jsonDecode(
      res.body,
    );
  }
}
