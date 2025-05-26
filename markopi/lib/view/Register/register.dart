import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Autentikasi_Controller.dart';
import 'package:markopi/models/register_request.dart';
import 'package:markopi/routes/route_name.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final authController = Get.put(AutentikasiController());

  final namaController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final provinsiController = TextEditingController();
  final kabupatenController = TextEditingController();
  final noTelpController = TextEditingController();
  String? jenisKelamin;

  bool isLoading = false;

  Future<void> _register() async {
    setState(() {
      isLoading = true;
    });

    final request = RegisterRequest(
      fullName: namaController.text,
      birthDate: tanggalLahirController.text,
      district: kabupatenController.text,
      email: emailController.text,
      gender: jenisKelamin!,
      password: passwordController.text,
      phoneNumber: noTelpController.text,
      province: provinsiController.text,
      username: usernameController.text,
    );

    await authController.register(request);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    tanggalLahirController.dispose();
    provinsiController.dispose();
    kabupatenController.dispose();
    noTelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actionsPadding: EdgeInsets.only(right: 5),
        centerTitle: true,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2696D6),
              shape: StadiumBorder(),
            ),
            onPressed: () => Get.toNamed(RouteName.login),
            child: Text(
              'Masuk',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) =>
                    val!.contains('@') ? null : 'Email tidak valid',
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              TextFormField(
                controller: tanggalLahirController,
                decoration:
                    InputDecoration(labelText: 'Tanggal Lahir (YYYY-MM-DD)'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                onChanged: (val) => setState(() => jenisKelamin = val),
                items: ['Laki-laki', 'Perempuan']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                validator: (val) => val == null ? 'Pilih jenis kelamin' : null,
              ),
              TextFormField(
                controller: provinsiController,
                decoration: InputDecoration(labelText: 'Provinsi'),
              ),
              TextFormField(
                controller: kabupatenController,
                decoration: InputDecoration(labelText: 'Kabupaten'),
              ),
              TextFormField(
                controller: noTelpController,
                decoration: InputDecoration(labelText: 'No. Telepon'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2696D6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() == true) {
                          _register();
                        }
                      },
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                      )
                    : Text("Daftar", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
