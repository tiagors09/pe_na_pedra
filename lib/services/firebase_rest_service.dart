import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pe_na_pedra/utils/env.dart';

/// Configure essas constantes via --dart-define em produção
class FirebaseRestService {
  FirebaseRestService._();
  static final instance = FirebaseRestService._();

  static const String apiKey = Env.apiKey;
  static const String dbUrl = Env.dbUrl;

  final http.Client _client = http.Client();

  Uri _pathUri(String path,
      {String? auth, Map<String, String>? queryParameters}) {
    final qp = <String, String>{};
    if (auth != null) qp['auth'] = auth;
    if (queryParameters != null) qp.addAll(queryParameters);
    final uri = Uri.parse('$dbUrl/$path.json').replace(queryParameters: qp);
    return uri;
  }

  Future<dynamic> get(String path, {String? auth}) async {
    final r = await _client.get(_pathUri(path, auth: auth));
    return jsonDecode(r.body);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body,
      {String? auth}) async {
    final r =
        await _client.post(_pathUri(path, auth: auth), body: jsonEncode(body));
    return jsonDecode(r.body);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body,
      {String? auth}) async {
    final r =
        await _client.put(_pathUri(path, auth: auth), body: jsonEncode(body));
    return jsonDecode(r.body);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body,
      {String? auth}) async {
    final r =
        await _client.patch(_pathUri(path, auth: auth), body: jsonEncode(body));
    return jsonDecode(r.body);
  }

  Future<dynamic> delete(String path, {String? auth}) async {
    final r = await _client.delete(_pathUri(path, auth: auth));
    return jsonDecode(r.body);
  }

  /// Simple SSE stream from Realtime Database.
  /// Returns a broadcast stream with decoded JSON payloads whenever data changes at path.
  Stream<Map<String, dynamic>> stream(String path, {String? auth}) {
    final controller = StreamController<Map<String, dynamic>>.broadcast();
    final uri = _pathUri(path, auth: auth);

    // create HTTP request with Accept: text/event-stream
    _client
        .send(http.Request('GET', uri)..headers['Accept'] = 'text/event-stream')
        .then((req) {
      req.stream.transform(utf8.decoder).transform(const LineSplitter()).listen(
          (line) {
        // Firebase SSE lines come like:
        // event: put
        // data: {"path":"/","data":{...}}
        if (line.startsWith('data: ')) {
          final payload = line.substring(6).trim();
          try {
            final decoded = jsonDecode(payload) as Map<String, dynamic>;
            controller.add(decoded);
          } catch (_) {
            // ignore parse errors
          }
        }
      }, onDone: () {
        controller.close();
      }, onError: (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
      });
    }).catchError((e, st) {
      if (!controller.isClosed) controller.addError(e, st);
    });

    return controller.stream;
  }
}
