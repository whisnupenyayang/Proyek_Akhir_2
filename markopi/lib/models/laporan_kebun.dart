class LaporanResponse {
  final List<LaporanKebunModel> laporan;
  final int totalProduktifitas;

  LaporanResponse({
    required this.laporan,
    required this.totalProduktifitas,
  });

  factory LaporanResponse.fromJson(Map<String, dynamic> json) {
    return LaporanResponse(
      laporan: (json['laporan'] as List)
          .map((item) => LaporanKebunModel.fromJson(item))
          .toList(),
      totalProduktifitas: json['total_produktifitas'] ?? 0,
    );
  }
}

class LaporanKebunModel {
  final int id;
  final String namaKebun;
  final String lokasi;
  final double luasKebun;
  final int totalPendapatan;
  final int totalPengeluaran;
  final int hasilProduktifitas;

  LaporanKebunModel({
    required this.id,
    required this.namaKebun,
    required this.lokasi,
    required this.luasKebun,
    required this.totalPendapatan,
    required this.totalPengeluaran,
    required this.hasilProduktifitas,
  });

  factory LaporanKebunModel.fromJson(Map<String, dynamic> json) {
    return LaporanKebunModel(
      id: json['id'],
      namaKebun: json['nama_kebun'],
      lokasi: json['lokasi'],
      luasKebun: double.parse(json['luas_kebun'].toString()),
      totalPendapatan: json['total_pendapatan'],
      totalPengeluaran: json['total_pengeluaran'],
      hasilProduktifitas: json['hasil_produktifitas'],
    );
  }
}

class LaporanDetailKebunModel {
  final int idKebun;
  final String namaKebun;
  final List<LaporanDetailItem> laporanDetail;

  LaporanDetailKebunModel({
    required this.idKebun,
    required this.namaKebun,
    required this.laporanDetail,
  });

  factory LaporanDetailKebunModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final detailList = data['laporanDetail'] ?? [];

    return LaporanDetailKebunModel(
      idKebun: data['id_kebun'] ?? 0,
      namaKebun: data['namaKebun'] ?? '',
      laporanDetail: (detailList as List)
          .map((item) => LaporanDetailItem.fromJson(item))
          .toList(),
    );
  }
}

class LaporanDetailItem {
  final String bulan;
  final int pendapatan;
  final int pengeluaran;
  final int hasilProduktivitas;

  LaporanDetailItem({
    required this.bulan,
    required this.pendapatan,
    required this.pengeluaran,
    required this.hasilProduktivitas,
  });

  factory LaporanDetailItem.fromJson(Map<String, dynamic> json) {
    return LaporanDetailItem(
      bulan: json['bulan'] ?? '',
      pendapatan: json['pendapatan'] ?? 0,
      pengeluaran: json['pengeluaran'] ?? 0,
      hasilProduktivitas: json['hasil_produktivitas'] ?? 0,
    );
  }
}
