import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pe_na_pedra/controller/profile_controller.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';

class ProfileViewModel {
  final _controller = ProfileController();

  final profileData = ValueNotifier<Map<String, dynamic>>({});
  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  bool _initialized = false;

  /// Carrega primeiro do cache → depois do servidor (refresh)
  Future<void> loadProfile(BuildContext context) async {
    if (_initialized) return;

    final global = GlobalStateProvider.of(context);

    // 1) Carrega instantaneamente do cache
    if (global.profile != null) {
      profileData.value = {...global.profile!};
      _initialized = true; // evita reler no mesmo ciclo
    }

    // 2) Busca dados mais recentes do servidor
    try {
      isLoading.value = true;

      final data = await _controller.fetchProfile(
        global.userId!,
        global.idToken!,
      );

      if (data != null) {
        final formatted = {
          'id': global.userId!,
          ...data,
        };

        // salva no provider
        global.setProfile(formatted);

        // salva no VM
        profileData.value = formatted;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
      _initialized = true;
    }
  }

  /// usado quando o usuário edita o perfil
  void refreshAfterEdit(BuildContext context) {
    _initialized = false;
    loadProfile(context);
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
