class User {
  final int id;
  final String namaLengkap;
  final String username;
  final String? email;
  final String? tanggalLahir;
  final String? jenisKelamin;
  final String? provinsi;
  final String? kabupaten;
  final String? noTelp;
  final String? role;

  User({
    required this.id,
    required this.namaLengkap,
    required this.username,
    this.email,
    this.tanggalLahir,
    this.jenisKelamin,
    this.provinsi,
    this.kabupaten,
    this.noTelp,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_users'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
      username: json['username'] ?? '',
      email: json['email'],
      tanggalLahir: json['tanggal_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      noTelp: json['no_telp'],
      role: json['role'],
    );
  }
}
