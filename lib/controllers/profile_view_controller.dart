import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ProfileViewController extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic>? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfileViewController({String? userId, String? userEmail}) {
    if (userId != null) {
      _profileData = {
        'email': userEmail,
      };
      fetchProfileData(userId);
    } else {
      _isLoading = false;
    }
  }

  Future<void> fetchProfileData(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await supabase.from('profiles').select().eq('id', userId).single();

      _profileData = {..._profileData!, ...response};
      log('Dados do perfil carregados: $_profileData',
          name: 'ProfileViewController');
    } on PostgrestException catch (e) {
      log(
        'PostgrestError (Provavelmente perfil incompleto/RLS): $e',
        name: 'ProfileViewController',
      );
      _errorMessage = 'Perfil não encontrado ou incompleto.';
    } catch (e, st) {
      log(
        'Erro ao buscar dados do perfil: $e',
        name: 'ProfileViewController',
        stackTrace: st,
      );
      _errorMessage = 'Erro ao carregar dados.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatBirthDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Não informado';
    try {
      final date = DateTime.parse(
        rawDate,
      );
      return DateFormat(
        'dd/MM/yyyy',
      ).format(
        date,
      );
    } catch (_) {
      return rawDate;
    }
  }

  @override
  void dispose() {
    log(
      'ProfileViewController disposed',
      name: 'ProfileViewController',
    );
    super.dispose();
  }
}
