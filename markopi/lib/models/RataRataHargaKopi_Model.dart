class RataRataHargakopi {
  int id;
  String jenis_kopi;
  int rata_rata_harga;
  int bulan;
  String tahun;

  RataRataHargakopi({
    required this.id,
    required this.jenis_kopi,
    required this.rata_rata_harga,
    required this.bulan,
    required this.tahun,
  });

  factory RataRataHargakopi.fromJson(Map<String, dynamic> json) {
    return RataRataHargakopi(
      id: json['id'],
      jenis_kopi: json['jenis_kopi'],
      rata_rata_harga: json['rata_rata_harga'],
      bulan: json['bulan'],
      tahun: json['tahun'],
    );
  }
}
