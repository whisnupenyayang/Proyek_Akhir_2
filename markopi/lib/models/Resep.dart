class Resep {
  final int resepId;
  final String namaResep;
  final String deskripsiResep;
  final String gambarResep;
  final String createdAt;
  final String updatedAt;

  Resep({
    required this.resepId,
    required this.namaResep,
    required this.deskripsiResep,
    required this.gambarResep,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      resepId: json['id'],
      namaResep: json['nama_resep'],
      deskripsiResep: json['deskripsi_resep'],
      gambarResep: json['gambar_resep'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
