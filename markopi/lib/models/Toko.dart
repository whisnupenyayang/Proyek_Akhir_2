class Toko {
  final int id;
  final String namaToko;
  final String lokasi;
  final String jamOperasional;
  final String fotoToko;

  Toko({
    required this.id,
    required this.namaToko,
    required this.lokasi,
    required this.jamOperasional,
    required this.fotoToko,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      id: json['id'] ?? 0,
      namaToko: json['nama_toko'] ?? '',
      lokasi: json['lokasi'] ?? '',
      jamOperasional: json['jam_operasional'] ?? '',
      fotoToko: json['foto_toko'] ?? '',
    );
  }
}
