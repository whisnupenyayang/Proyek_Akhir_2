import 'package:hive/hive.dart';
part 'User_Storage.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String namaLengkap;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String provinsi;
  @HiveField(3)
  final String kabupaten;

  UserModel({
    required this.namaLengkap,
    required this.email,
    required this.provinsi,
    required this.kabupaten,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      namaLengkap: json['nama_lengkap'] ?? '',
      email: json['email'],
      provinsi: json['provinsi'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
    );
  }
  @override
  String toString() {
    return 'UserModel(namaLengkap: $namaLengkap, email: $email, provinsi: $provinsi, kabupaten: $kabupaten)';
  }
}
