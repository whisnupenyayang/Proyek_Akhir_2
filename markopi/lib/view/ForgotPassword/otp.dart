import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/forgot_password.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatelessWidget {
  OtpVerificationPage({super.key});

  final ForgotPasswordController _forgotPasswordController =
      Get.find<ForgotPasswordController>();

  void handleOtp() {
    final otp = _forgotPasswordController.otp.value.trim();
    if (otp.isEmpty || otp.length < 6) {
      Get.snackbar('Peringatan', 'OTP harus 6 digit.');
      return;
    }

    Get.toNamed(RouteName.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi Kode OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Masukkan kode OTP yang dikirim ke email kamu:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${_forgotPasswordController.email.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Pinput(
              length: 6,
              onChanged: (value) => _forgotPasswordController.otp.value = value,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2696D6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: handleOtp,
              child: const Text('Verifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
