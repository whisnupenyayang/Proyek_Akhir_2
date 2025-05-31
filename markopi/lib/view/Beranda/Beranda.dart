import 'package:flutter/material.dart';
import 'package:markopi/service/User_Storage.dart';
import 'package:markopi/service/User_Storage_Service.dart';
import './MyAppBar.dart';
import './MyBody.dart';

import 'package:hive_flutter/hive_flutter.dart';

// Kelas Beranda adalah halaman utama aplikasi.
// Di sini, kita membuka dan mengambil data pengguna yang disimpan.
class Beranda extends StatelessWidget {
  final userStorage = UserStorage(); // Untuk mengakses data pengguna.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<UserModel>>(
      future: userStorage.openBox(), // Membuka data pengguna dari penyimpanan.
      builder: (context, snapshot) {
        // Jika data sedang dimuat, tampilkan loading.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Menampilkan loading.
        }

        // Setelah data dimuat, ambil data pengguna.
        final user = userStorage.getUser();
        print(user); // Menampilkan data pengguna di console.

        // Menampilkan tampilan utama aplikasi.
        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4), // Mengatur warna latar belakang.
          
          // AppBar adalah bagian atas halaman (header).
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70), // Mengatur tinggi AppBar.
            child: Container(
              color: Colors.white, // Menentukan warna AppBar.
              padding: const EdgeInsets.only(top: 12), // Menambah jarak atas.
              child: MyAppBar(), // Memanggil widget AppBar.
            ),
          ),
          
          // Body adalah bagian utama halaman untuk menampilkan konten.
          body: BerandaBody(), // Menampilkan konten utama halaman.
        );
      },
    );
  }
}
