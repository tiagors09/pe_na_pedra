import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/controller/profile_controller.dart';

class ProfileViewModel {
  final _controller = ProfileController();

  // Notifiers
  final profileData = ValueNotifier<Map<String, dynamic>>({});
  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  bool _initialized = false;

  Future<void> loadProfile(String userId, String idToken) async {
    if (_initialized) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await _controller.fetchProfile(userId, idToken);

      profileData.value = {
        'id': userId,
        ...(data ?? {}),
      };

      _initialized = true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void invalidateCache() {
    _initialized = false;
  }

  String formatBirthDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final date = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return raw;
    }
  }
}
