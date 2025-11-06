// profile_view_controller.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ProfileViewController extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic> _profileData = {};
  bool _isLoading = false;
  String? _errorMessage;
  bool _isProfileCached = false;

  Map<String, dynamic> get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfileViewController();

  void initializeProfile(String userId, String userEmail) {
    if (_isProfileCached) {
      if (_profileData['email'] != userEmail) {
        _profileData['email'] = userEmail;
        notifyListeners();
      }
      return;
    }

    _profileData = {'id': userId, 'email': userEmail};

    notifyListeners();

    fetchProfileData(userId);
  }

  Future<void> fetchProfileData(String userId) async {
    if (_isProfileCached && _errorMessage == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase
          .from('profiles')
          .select('full_name, phone, birth_date, address')
          .eq('id', userId)
          .single();

      _profileData = {
        'id': userId,
        'email': _profileData['email'],
        'fullName': response['full_name'],
        'phone': response['phone'],
        'birthDate': response['birth_date'],
        'address': response['address'],
      };

      _isProfileCached = true;
    } on PostgrestException catch (_) {
      _errorMessage = 'Perfil incompleto. Por favor, edite seu perfil.';
    } catch (_) {
      _errorMessage = 'Erro ao carregar dados.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void invalidateCache() {
    _isProfileCached = false;
  }

  String formatBirthDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return '';
    }
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }
}
