import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:markopi/service/pengajuan.dart';
import 'package:markopi/view/Profile/Profile.dart';

class PengajuanController extends GetxController {
  final deskripsiController = TextEditingController();
  final tipePengajuan = 'fasilitator'.obs;
  final isLoading = false.obs;
  final status = 0.obs;

  final fotoKtp = Rx<File?>(null);
  final fotoSelfie = Rx<File?>(null);
  final fotoSertifikat = Rx<File?>(null);

  final picker = ImagePicker();

  Future<void> pickImage(Rx<File?> target) async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      target.value = File(picked.path);
    }
  }

  Future<void> submitPengajuan() async {
    isLoading.value = true;
    try {
      var formData = dio.FormData.fromMap({
        'deskripsi_pengalaman': deskripsiController.text,
        'type_pengajuan': tipePengajuan.value,
        if (fotoKtp.value != null)
          'foto_ktp': await dio.MultipartFile.fromFile(fotoKtp.value!.path),
        if (fotoSelfie.value != null)
          'foto_selfie':
              await dio.MultipartFile.fromFile(fotoSelfie.value!.path),
        if (fotoSertifikat.value != null)
          'foto_sertifikat':
              await dio.MultipartFile.fromFile(fotoSertifikat.value!.path),
      });

      var response = await PengajuanService.submitPengajuan(formData);

      Get.snackbar('Sukses', response['message']);
      Get.to(() => const ProfileView());
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat mengirim pengajuan');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPengajuanStatus() async {
    try {
      var response = await PengajuanService.checkPengajuanStatus();
      if (response['data'] != null) {
        status.value = int.parse(response['data']['status']);
      } else {
        status.value = -1;
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }
}
