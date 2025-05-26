import 'package:intl/intl.dart';

class Artikel {
  final int id;
  final String judulArtikel;
  final String isiArtikel;
  final String tanggal;
  final List<String> imageUrls;
  final int userId;

  Artikel({
    required this.id,
    required this.judulArtikel,
    required this.isiArtikel,
    required this.tanggal,
    required this.imageUrls,
    required this.userId,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
  List<String> imageUrls = [];

  if (json['images'] != null && json['images'] is List) {
    imageUrls = (json['images'] as List)
        .map((img) => img['gambar_url'].toString())
        .toList();
  }

  DateTime createdAt = DateTime.parse(json['created_at']);
  final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
  final formattedDate = formatter.format(createdAt);

  return Artikel(
    id: json['id'] ?? 0,
    judulArtikel: json['judul_artikel'] ?? '',
    isiArtikel: json['isi_artikel'] ?? '',
    tanggal: formattedDate,
    imageUrls: imageUrls,
    userId: json['user_id'] ?? 0,
  );
}

}
