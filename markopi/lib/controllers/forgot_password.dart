import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/providers/forgot_password.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:markopi/providers/otp.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordConnect _forgotPasswordConnect = ForgotPasswordConnect();

  RxString email = ''.obs;
  RxString otp = ''.obs;
  RxString password = ''.obs;

  Future<void> sendEmail() async {
    final response = await sendToMail(email.value);

    debugPrint('email data: ${response.data}');

    if (response.data['success'] == true) {
      Get.snackbar('Kode dikirim',
          response.data['message'] ?? 'Silahkan cek email anda');
      Get.toNamed(RouteName.otp);
    } else {
      Get.snackbar('Kode gagal dikirim',
          response.data['message'] ?? 'Maaf, kode tidak terkirim');
    }
  }

  Future<void> resetPassword() async {
    final response = await _forgotPasswordConnect.resetPassword(
        email.value, otp.value, password.value);

    if (response.body['success'] == true) {
      Get.snackbar(
          'Berhasil', response.body['message'] ?? 'Password telah diganti');
    } else {
      Get.snackbar(
          'Gagal', response.body['message'] ?? 'Gagal mengganti password');
    }
  }
}
