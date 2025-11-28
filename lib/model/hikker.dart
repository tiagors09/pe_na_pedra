import 'package:pe_na_pedra/utils/enums.dart';

class Hikker {
  final String id;
  final String fullName;
  final String address;
  final String birthDate;
  final String phone;
  final UserRoles role;

  Hikker({
    required this.id,
    required this.fullName,
    required this.address,
    required this.birthDate,
    required this.phone,
    required this.role,
  });

  /// Cria o model a partir do Firebase (Map)
  factory Hikker.fromMap(String id, Map<dynamic, dynamic> data) {
    return Hikker(
      id: id,
      fullName: data['fullName'] ?? '',
      address: data['address'] ?? '',
      birthDate: data['birthDate'] ?? '',
      phone: data['phone'] ?? '',
      role: UserRoles.values.byName(data['role'] ?? 'hikke'),
    );
  }

  /// Converte para Map para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'birthDate': birthDate,
      'phone': phone,
      'role': role,
    };
  }

  /// Facilita a edição
  Hikker copyWith({
    String? id,
    String? fullName,
    String? address,
    String? birthDate,
    String? phone,
    UserRoles? role,
  }) {
    return Hikker(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}
