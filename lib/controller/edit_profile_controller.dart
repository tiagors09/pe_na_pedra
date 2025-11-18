// lib/controllers/edit_profile_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/viewmodel/edit_profile_viewmodel.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';

class EditProfileController {
  Future<void> submit(
    BuildContext context,
    GlobalState globalState,
    EditProfileMode mode,
    EditProfileViewModel viewModel,
  ) async {
    if (!(viewModel.form.currentState?.validate() ?? false)) return;
    viewModel.form.currentState!.save();

    try {
      viewModel.setLoading(true);

      final userId = globalState.userId;
      final idToken = globalState.idToken;

      if (userId == null || idToken == null) {
        throw Exception("Usuário não autenticado.");
      }

      final profileData = {
        'fullName': viewModel.formData['fullName'],
        'phone': viewModel.formData['phone'],
        'birthDate': viewModel.formData['birthDate'],
        'address': viewModel.formData['address'],
        'isAdm': globalState.profile?['isAdm'] ?? false, // mantém admin
      };

      await globalState.setProfile(profileData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil salvo com sucesso!')),
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }

      log('Perfil atualizado com sucesso', name: 'EditProfileController');
    } catch (e, st) {
      log('Erro ao salvar perfil: $e',
          stackTrace: st, name: 'EditProfileController');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar perfil: $e')),
        );
      }
    } finally {
      viewModel.setLoading(false);
    }
  }
}
