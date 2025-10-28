abstract class Configuration {
  /// Supabase URL
  static String get supabaseUrl {
    const url = String.fromEnvironment(
      'SUPABASE_URL',
    );

    if (url.isEmpty) {
      throw Exception(
        'SUPABASE_URL não definida. Passe via --dart-define=SUPABASE_URL=...',
      );
    }

    return url;
  }

  /// Supabase Key
  static String get supabaseKey {
    const key = String.fromEnvironment(
      'SUPABASE_KEY',
    );

    if (key.isEmpty) {
      throw Exception(
        'SUPABASE_KEY não definida. Passe via --dart-define=SUPABASE_KEY=...',
      );
    }

    return key;
  }
}
