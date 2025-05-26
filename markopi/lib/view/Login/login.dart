import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Autentikasi_Controller.dart';
import 'package:markopi/service/token_storage.dart';
import 'package:markopi/routes/route_name.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final autentikasiController = Get.put(AutentikasiController());
  bool _obscurePassword = true;
  String? token;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        titleSpacing: 20,
        centerTitle: true,
        title: const Text("Masuk"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _username,
              decoration: InputDecoration(
                labelText: "Username",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Your password",
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      _obscurePassword ? "Show" : "Hide",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                String username = _username.text;
                String password = _password.text;
                print('username : $username \npassword : $password');
                await autentikasiController.login(username, password);
                if (autentikasiController.sukses.value) {
                  autentikasiController.sukses.value = false;
                  token = await TokenStorage.getToken();

                  print(token);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2696D6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Masuk", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Get.toNamed(RouteName.register),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2696D6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child:
                  const Text("Daftar", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () => Get.toNamed(RouteName.forgotPassword),
              child: Text("Lupa Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
