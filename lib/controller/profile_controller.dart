import 'package:pe_na_pedra/utils/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController {
  final SupabaseClient supabase = SupabaseService.instance.client;

  Future<Map<String, dynamic>> fetchProfileData(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('full_name, phone, birth_date, address, is_adm')
          .eq('id', userId)
          .single();

      return {
        'fullName': response['full_name'],
        'phone': response['phone'],
        'birthDate': response['birth_date'],
        'address': response['address'],
        'is_adm': response['is_adm'],
      };
    } on PostgrestException {
      throw Exception('Perfil incompleto. Por favor, edite seu perfil.');
    } catch (_) {
      throw Exception('Erro ao carregar dados do perfil.');
    }
  }
}
