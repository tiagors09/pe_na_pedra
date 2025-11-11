import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/controller/profile_controller.dart';

class ProfileViewModel extends ChangeNotifier {
  final _controller = ProfileController();

  Map<String, dynamic> _profileData = {};
  bool _isLoading = false;
  String? _errorMessage;
  bool _isProfileCached = false;

  Map<String, dynamic> get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile(String userId, String userEmail) async {
    if (_isProfileCached) return;

    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _controller.fetchProfileData(userId);
      _profileData = {
        'id': userId,
        'email': userEmail,
        ...data,
      };
      _isProfileCached = true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void invalidateCache() {
    _isProfileCached = false;
    notifyListeners();
  }

  String formatBirthDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
