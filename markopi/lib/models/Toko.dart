class Toko {
  final int id;
  final String namaToko;
  final String lokasi;
  final String jamOperasional;
  final String fotoToko;
  final double latitude;  // Menambahkan properti latitude
  final double longitude; // Menambahkan properti longitude

  Toko({
    required this.id,
    required this.namaToko,
    required this.lokasi,
    required this.jamOperasional,
    required this.fotoToko,
    required this.latitude,  // Menambahkan parameter latitude
    required this.longitude, // Menambahkan parameter longitude
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      id: json['id'] ?? 0,
      namaToko: json['nama_toko'] ?? '',
      lokasi: json['lokasi'] ?? '',
      jamOperasional: json['jam_operasional'] ?? '',
      fotoToko: json['foto_toko'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,  // Menambahkan parsing latitude
      longitude: json['longitude']?.toDouble() ?? 0.0, // Menambahkan parsing longitude
    );
  }
}
