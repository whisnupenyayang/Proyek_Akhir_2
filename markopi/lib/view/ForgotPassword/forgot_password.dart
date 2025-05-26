import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/forgot_password.dart';
import 'package:markopi/routes/route_name.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final _forgotPassword = Get.put(ForgotPasswordController());

    RxBool _isLoading = false.obs;

    void handleSendEmail() async {
      _isLoading.value = true;

      await _forgotPassword.sendEmail();

      _isLoading.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 25,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => _forgotPassword.email.value = value,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: _isLoading.value ? null : handleSendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2696D6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading.value
                    ? CircularProgressIndicator(
                        padding: EdgeInsets.symmetric(vertical: 5))
                    : Text('Kirim Kode'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
