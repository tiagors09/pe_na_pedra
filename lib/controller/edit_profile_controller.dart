import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pe_na_pedra/provider/global_state.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/viewmodel/edit_profile_viewmodel.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController {
  final SupabaseClient supabase = Supabase.instance.client;

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

      final userId = globalState.user?.id;
      if (userId == null) return;

      final values = {
        'id': userId,
        'full_name': viewModel.formData['fullName'],
        'phone': viewModel.formData['phone'],
        'birth_date': viewModel.formData['birthDate'],
        'address': viewModel.formData['address'],
      };

      switch (mode) {
        case EditProfileMode.completeProfile:
          await supabase.from('profiles').insert(values);
          break;

        case EditProfileMode.editProfile:
          await supabase.from('profiles').update(values).eq('id', userId);

          if (viewModel.formData['password'].isNotEmpty) {
            await supabase.auth.updateUser(
              UserAttributes(password: viewModel.formData['password']),
            );
          }
          break;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }

      log('Perfil atualizado com sucesso', name: 'EditProfileController');
    } catch (e, st) {
      log('Erro ao salvar perfil: $e',
          name: 'EditProfileController', stackTrace: st);
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
