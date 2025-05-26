import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/forgot_password.dart';
import 'package:markopi/routes/route_name.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final _formKey = GlobalKey<FormState>();

  final ForgotPasswordController _forgotPasswordController =
      Get.find<ForgotPasswordController>();

  final RxBool _isLoading = false.obs;

  void _submit() async {
    _isLoading.value = true;

    if (_formKey.currentState!.validate()) {
      await _forgotPasswordController.resetPassword();
      Get.toNamed(RouteName.login);
    }

    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Masukkan password baru Anda:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) =>
                    _forgotPasswordController.password.value = value,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2696D6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: _isLoading.value ? null : _submit,
                  child: _isLoading.value
                      ? CircularProgressIndicator(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        )
                      : const Text('Ubah Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
