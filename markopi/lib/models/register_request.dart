class RegisterRequest {
  String fullName;
  String username;
  String email;
  String password;
  String birthDate;
  String gender;
  String province;
  String district;
  String phoneNumber;

  RegisterRequest({
    required this.fullName,
    required this.username,
    required this.birthDate,
    required this.district,
    required this.email,
    required this.gender,
    required this.password,
    required this.phoneNumber,
    required this.province,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': fullName,
      'username': username,
      'email': email,
      'password': password,
      'tanggal_lahir': birthDate,
      'jenis_kelamin': gender,
      'provinsi': province,
      'kabupaten': district,
      'no_telp': phoneNumber,
    };
  }
}
