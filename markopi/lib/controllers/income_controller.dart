import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:markopi/providers/Connection.dart';
import 'package:markopi/service/token_storage.dart';
import 'package:markopi/view/Laporan/LaporanPage.dart';

class IncomeController extends GetxController {
  var isLoading = true.obs;
  var pendapatanList = [].obs;
  var pengeluaranList = [].obs;

  Future<void> fetchData(String kebunId, String bulan) async {
    try {
      final String? token = await TokenStorage.getToken();
      if (token == null) {
        Get.snackbar("Gagal", "Anda Belum Login");
      }
      isLoading.value = true;
      final url = Uri.parse(Connection.buildUrl(
          "/laporan/bulanan/income-expance?id=${kebunId}&bulan=${bulan}"));

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        pendapatanList.value = data['pendapatan'] ?? [];
        pengeluaranList.value = data['pengeluaran'] ?? [];
      } else {
        Get.snackbar("Error", "Gagal memuat data");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  static Future<bool> kirimPendapatan({
    required String jenisKopi,
    required String tempatJual,
    required String tanggal,
    required String banyakKopi,
    required String hargaKopi,
    required String kebun_id
  }) async {
    try {
      final String? token = await TokenStorage.getToken();
      if (token == null) {
        Get.snackbar("Gagal", "Anda Belum Login");
        return false;
      }

      final url = Uri.parse("${Connection.buildUrl("/pendapatan/store/${1}")}");

      final now = DateTime.now();
      final String tanggalSekarang =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final int hargaKopiInt = int.tryParse(hargaKopi) ?? 0;
      final int banyakKopiInt = int.tryParse(banyakKopi) ?? 0;
      final body = {
        "kebun_id": kebun_id,
        "jenis_kopi": jenisKopi,
        "tempat_penjualan": tempatJual,
        "tanggal_panen": tanggal,
        "tanggal_penjualan": tanggalSekarang,
        "berat_kg": banyakKopi,
        "harga_per_kg": hargaKopi,
        "total_pendapatan": hargaKopiInt * banyakKopiInt,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);
      final status = responseData['status'];

      debugPrint(response.body);
      if (status == "success") {
        Get.off(LaporanPage());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> kirimPengeluaran({
    required String jenisPengeluaran,
    required String jumlah,
    required String kebun_id,
  }) async {
    try {
      final String? token = await TokenStorage.getToken();
      if (token == null) {
        Get.snackbar("Gagal", "Anda Belum Login");
        return false;
      }
      final url =
          Uri.parse("${Connection.buildUrl("/pengeluaran/store/${1}")}");

      final now = DateTime.now();
      final String tanggalSekarang =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final body = {
        "kebun_id": kebun_id,
        "deskripsi_biaya": jenisPengeluaran,
        "nominal": jumlah,
        "tanggal": tanggalSekarang,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);
      debugPrint(response.body);
      final status = responseData['status'];

      if (status == "success") {
        Get.off(LaporanPage());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
