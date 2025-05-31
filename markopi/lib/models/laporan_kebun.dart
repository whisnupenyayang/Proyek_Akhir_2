class LaporanResponse {
  final List<LaporanKebunModel> laporan;
  final int totalProduktifitas;
  
  LaporanResponse({
    required this.laporan,
    required this.totalProduktifitas,
  });
  
  factory LaporanResponse.fromJson(Map<String, dynamic> json) {
    // Debug: Print untuk melihat struktur JSON
    print('LaporanResponse parsing json: $json');
    print('Available keys: ${json.keys.toList()}');
   
    // Cek berbagai kemungkinan struktur response
    List<dynamic> laporanList = [];
    int totalProd = 0;
   
    try {
      // Kemungkinan 1: data.laporan
      if (json.containsKey('data') && json['data'] != null) {
        final data = json['data'];
        if (data is Map<String, dynamic>) {
          if (data.containsKey('laporan') && data['laporan'] is List) {
            laporanList = data['laporan'] as List<dynamic>;
            totalProd = _parseToInt(data['total_produktifitas']);
          }
        } else if (data is List) {
          // data adalah array langsung
          laporanList = data;
          totalProd = _parseToInt(json['total_produktifitas']);
        }
      }
      // Kemungkinan 2: langsung di root
      else if (json.containsKey('laporan') && json['laporan'] is List) {
        laporanList = json['laporan'] as List<dynamic>;
        totalProd = _parseToInt(json['total_produktifitas']);
      }
      
      print('Found ${laporanList.length} laporan items');
      
      return LaporanResponse(
        laporan: laporanList
            .where((item) => item is Map<String, dynamic>) // Filter only valid maps
            .map((item) => LaporanKebunModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        totalProduktifitas: totalProd,
      );
    } catch (e) {
      print('Error parsing LaporanResponse: $e');
      return LaporanResponse(
        laporan: [],
        totalProduktifitas: 0,
      );
    }
  }
  
  // Helper method untuk parsing int yang aman
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
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
    try {
      return LaporanKebunModel(
        id: _parseToInt(json['id']),
        namaKebun: _parseToString(json['nama_kebun']),
        lokasi: _parseToString(json['lokasi']),
        luasKebun: _parseToDouble(json['luas_kebun']),
        totalPendapatan: _parseToInt(json['total_pendapatan']),
        totalPengeluaran: _parseToInt(json['total_pengeluaran']),
        hasilProduktifitas: _parseToInt(json['hasil_produktifitas']),
      );
    } catch (e) {
      print('Error parsing LaporanKebunModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  
  // Helper methods untuk parsing yang aman
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }
  
  static String _parseToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
  
  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
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
    try {
      final data = json['data'] ?? {};
      
      // Pastikan data adalah Map
      if (data is! Map<String, dynamic>) {
        throw Exception('Expected data to be Map<String, dynamic>, got ${data.runtimeType}');
      }
      
      final detailList = data['laporanDetail'] ?? [];
      
      // Pastikan detailList adalah List
      if (detailList is! List) {
        throw Exception('Expected laporanDetail to be List, got ${detailList.runtimeType}');
      }
      
      return LaporanDetailKebunModel(
        idKebun: _parseToInt(data['id_kebun']),
        namaKebun: _parseToString(data['namaKebun']),
        laporanDetail: detailList
            .where((item) => item is Map<String, dynamic>)
            .map((item) => LaporanDetailItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Error parsing LaporanDetailKebunModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }
  
  static String _parseToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
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
    try {
      return LaporanDetailItem(
        bulan: _parseToString(json['bulan']),
        pendapatan: _parseToInt(json['pendapatan']),
        pengeluaran: _parseToInt(json['pengeluaran']),
        hasilProduktivitas: _parseToInt(json['hasil_produktivitas']),
      );
    } catch (e) {
      print('Error parsing LaporanDetailItem: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }
  
  static String _parseToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}