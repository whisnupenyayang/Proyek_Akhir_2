class JenisTahapKegiatan {
  int id;
  String judul;
  String? deskripsi;
  String nama_file;
  String url_gambar;
  int tahapan_kegiatan_id;
  String created_at;
  String updated_at;

  JenisTahapKegiatan({
    required this.id,
    required this.judul,
    this.deskripsi,
    required this.nama_file,
    required this.url_gambar,
    required this.tahapan_kegiatan_id,
    required this.created_at,
    required this.updated_at,
  });

  factory JenisTahapKegiatan.fromJson(Map<String, dynamic> json) {
    return JenisTahapKegiatan(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      nama_file: json['nama_file'],
      url_gambar: json['url_gambar'],
      tahapan_kegiatan_id: json['tahapan_kegiatan_id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  factory JenisTahapKegiatan.empty() {
    return JenisTahapKegiatan(
      id: 0,
      judul: '',
      deskripsi: '',
      nama_file: '',
      url_gambar: '',
      tahapan_kegiatan_id: 0,
      created_at: '',
      updated_at: '',
    );
  }
}
