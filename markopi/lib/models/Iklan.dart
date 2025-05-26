class Iklan {
  final int id;
  final String judulIklan;
  final String gambar;
  final String link;

  Iklan({
    required this.id,
    required this.judulIklan,
    required this.gambar,
    required this.link,
  });

  factory Iklan.fromJson(Map<String, dynamic> json) {
  return Iklan(
    id: json['id'],
    judulIklan: json['judul_iklan'] ?? '',
    gambar: json['gambar_url'] ?? '',  // pakai gambar_url, bukan gambar
    link: json['link'] ?? '',
  );
}

}
