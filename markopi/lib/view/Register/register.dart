import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Autentikasi_Controller.dart';
import 'package:markopi/models/register_request.dart';
import 'package:markopi/routes/route_name.dart';

// Custom TextInputFormatter untuk format YYYY-MM-DD
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Hapus semua karakter non-digit
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Batasi maksimal 8 digit (YYYYMMDD)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }
    
    String formatted = '';
    
    if (digitsOnly.isNotEmpty) {
      // Format: YYYY
      if (digitsOnly.length <= 4) {
        formatted = digitsOnly;
      }
      // Format: YYYY-MM
      else if (digitsOnly.length <= 6) {
        formatted = '${digitsOnly.substring(0, 4)}-${digitsOnly.substring(4)}';
      }
      // Format: YYYY-MM-DD
      else {
        formatted = '${digitsOnly.substring(0, 4)}-${digitsOnly.substring(4, 6)}-${digitsOnly.substring(6)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

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

  // Validator untuk tanggal
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wajib diisi';
    }
    
    if (value.length != 10) {
      return 'Format: YYYY-MM-DD';
    }
    
    try {
      DateTime.parse(value);
      
      // Validasi tambahan untuk tahun yang masuk akal
      final year = int.parse(value.substring(0, 4));
      final currentYear = DateTime.now().year;
      
      if (year < 1900 || year > currentYear) {
        return 'Tahun tidak valid';
      }
      
      return null;
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

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

  // Fungsi untuk membuka date picker sebagai alternatif
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'), // Bahasa Indonesia
    );
    
    if (picked != null) {
      // Format ke YYYY-MM-DD
      final formattedDate = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      tanggalLahirController.text = formattedDate;
    }
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
              
              // PILIHAN 1: Input dengan formatter otomatis
              TextFormField(
                controller: tanggalLahirController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  hintText: 'Tahun-Bulan-Hari (contoh: 2005-03-12)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  DateInputFormatter(), // Formatter custom
                ],
                validator: _validateDate,
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
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: kabupatenController,
                decoration: InputDecoration(labelText: 'Kabupaten/Kota'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: noTelpController,
                decoration: InputDecoration(labelText: 'No. Telepon'),
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
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