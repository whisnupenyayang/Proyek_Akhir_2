class TahapanKegiatan {
  int id;
  String nama_tahapan;
  String jenis_kopi;
  String kegiatan;

  TahapanKegiatan({
    required this.id,
    required this.nama_tahapan,
    required this.jenis_kopi,
    required this.kegiatan,
  });

  factory TahapanKegiatan.fromJson(Map<String, dynamic> json) {
    return TahapanKegiatan(
      id: json['id'],
      nama_tahapan: json['nama_tahapan'],
      jenis_kopi: json['jenis_kopi'],
      kegiatan: json['kegiatan'],
    );
  }
}
