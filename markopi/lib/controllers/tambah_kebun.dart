import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/service/laporan_service.dart';

class TambahKebunController extends GetxController {
  final namaKebun = TextEditingController();
  final lokasi = TextEditingController();
  final luasKebun = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final loading = false.obs;

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    try {
      final response = await LaporanService.addLaporan(
        namaKebun.text,
        lokasi.text,
        luasKebun.text,
      );

      if (response.data['status'] == 'success') {
        await Get.snackbar('Sukses', 'Data kebun berhasil disimpan',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    namaKebun.dispose();
    lokasi.dispose();
    luasKebun.dispose();
    super.onClose();
  }
}
