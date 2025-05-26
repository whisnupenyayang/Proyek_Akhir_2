import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:markopi/models/Pengepul_Model.dart';
import 'package:markopi/models/RataRataHargaKopi_Model.dart';
import 'package:markopi/providers/Pengepul_Providers.dart';
import 'package:markopi/service/token_storage.dart';

class PengepulController extends GetxController {
  var pengepul = <Pengepul>[].obs;  // Semua pengepul
  var pengepulByUser = <Pengepul>[].obs;  // Pengepul milik pengguna
  var rataRataHargaKopi = <RataRataHargakopi>[].obs;
  var detailPengepul = Pengepul.empty().obs;

  final pengepulProvider = PengepulProviders();

  // Ambil data semua pengepul
  Future<void> fetchPengepul() async {
    final response = await pengepulProvider.getPengepul();
    if (response.statusCode == 200) {
      final List<dynamic> data = response.body;
      pengepul.value = data.map((e) => Pengepul.fromJson(e)).toList();
    } else {
      Get.snackbar('Error', 'Gagal mengambil data pengepul');
    }
  }

  // Ambil data pengepul milik pengguna
  Future<void> fetchPengepulByUser() async {
    final String? token = await TokenStorage.getToken();
    if (token == null) {
      Get.snackbar('Error', 'Anda belum login');
      return;
    }

    final response = await pengepulProvider.getDataPengepulByid(token);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.body;
      pengepulByUser.value = data.map((e) => Pengepul.fromJson(e)).toList();
    } else {
      Get.snackbar('Error', 'Gagal mengambil data pengepul milik pengguna');
    }
  }

  // Ambil detail pengepul
  Future<void> fetcPengepulDetail(int id) async {
    final response = await pengepulProvider.getPengepulDetail(id);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.body;
      detailPengepul.value = Pengepul.fromJson(data);
    } else {
      Get.snackbar('Error', 'Gagal mengambil detail pengepul');
    }
  }

  // Tambah data pengepul
  Future<void> tambahPengepul({
    required String nama,
    required String alamat,
    required String harga,
    required File gambar,
    required String telepon,
    required String jenisKopi,
  }) async {
    final String? token = await TokenStorage.getToken();

    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan");
      return;
    }

    final response = await pengepulProvider.postPengepul(
      nama,          // nama_toko
      jenisKopi,     // jenis_kopi
      int.parse(harga),
      telepon,       // nomor_telepon
      alamat,
      gambar,
      token,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      Get.snackbar('Berhasil', responseBody['message'] ?? 'Upload berhasil');
      fetchPengepul(); // Update daftar pengepul
      fetchPengepulByUser(); // Update daftar pengepul milik pengguna
    } else {
      final errorBody = jsonDecode(response.body);
      Get.snackbar('Gagal', errorBody['message'] ?? 'Upload gagal');
    }
  }

  // Edit data pengepul
  Future<void> editPengepul({
    required int id,
    required String nama,
    required String alamat,
    required String harga,
    required String telepon,
    required String jenisKopi,
  }) async {
    final String? token = await TokenStorage.getToken();

    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan");
      return;
    }

    final response = await pengepulProvider.editPengepul(
      id,
      nama,
      jenisKopi,
      int.parse(harga),
      telepon,
      alamat,
      token,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      Get.snackbar('Berhasil', responseBody['message'] ?? 'Edit berhasil');
      fetchPengepul(); // Update daftar pengepul
      fetchPengepulByUser(); // Update daftar pengepul milik pengguna
    } else {
      final errorBody = jsonDecode(response.body);
      Get.snackbar('Gagal', errorBody['message'] ?? 'Edit gagal');
    }
  }

  // Hapus data pengepul
  Future<void> deletePengepul(int id) async {
    final String? token = await TokenStorage.getToken();

    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan");
      return;
    }

    final response = await pengepulProvider.deletePengepul(id, token);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      Get.snackbar('Berhasil', responseBody['message'] ?? 'Hapus berhasil');
      fetchPengepul(); // Update daftar pengepul
      fetchPengepulByUser(); // Update daftar pengepul milik pengguna
    } else {
      final errorBody = jsonDecode(response.body);
      Get.snackbar('Gagal', errorBody['message'] ?? 'Hapus gagal');
    }
  }

  // Fetch rata-rata harga kopi
  Future<void> fetchRataRataHarga(String jenis_kopi, String tahun) async {
    final response =
        await pengepulProvider.getHargaRataRataKopi(jenis_kopi, tahun);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.body['data'];
      rataRataHargaKopi.value =
          data.map((e) => RataRataHargakopi.fromJson(e)).toList();
    } else {
      Get.snackbar('Error', 'Gagal mengambil data');
    }
  }
}
