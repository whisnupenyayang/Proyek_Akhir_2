import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/BottomNavController.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:markopi/service/token_storage.dart';
import 'package:markopi/view/Artikel/List_artikel.dart';
import 'package:markopi/view/Beranda/Beranda.dart';
import 'package:markopi/view/HargaKopi/ListPengepulFinal.dart';
import 'package:markopi/view/forum/ListForum.dart';
import 'package:markopi/view/Profile/Profile.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller =
        Get.put(BottomNavController()); // Mengakses BottomNavController

    return Scaffold(
      body: Obx(() {
        // Ganti tampilan berdasarkan index yang dipilih
        switch (controller.selectedIndex.value) {
          case 0:
            return Beranda(); // Halaman pertama (Beranda)
          case 1:
            return ListForum(); // Halaman Forum
          case 2:
            return KopiPage(); // Halaman Pengepul (Kopi)
          case 3:
            return ListArtikel(); // Halaman Artikel
          case 4:
            return ProfileView(); // Halaman Profil
          default:
            return Beranda(); // Fallback ke Beranda jika index tidak ditemukan
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.black, size: 40),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined,
                  color: Colors.black, size: 40),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_sharp, color: Colors.black, size: 40),
              label: 'Pengepul',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, color: Colors.black, size: 40),
              label: 'Artikel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined,
                  color: Colors.black, size: 40),
              label: 'Profil',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: const Color(0xFF297CBB), // Warna saat item dipilih
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) async {
            final token = await TokenStorage.getToken(); // Cek apakah token ada
            if (index == 0 || index == 1 || index == 2 || index == 3) {
              // Akses Beranda, Forum, Pengepul, dan Artikel selalu diizinkan, tanpa login
              controller.onItemTapped(index);
            } else if (index == 4 && token == null) {
              // Jika token tidak ada dan pengguna mencoba mengakses Profil
              Get.snackbar(
                "Anda belum login", // Judul Snackbar
                "Silakan login untuk mengakses halaman profil", // Pesan Snackbar
                snackPosition: SnackPosition.TOP, // Posisi di atas layar
                backgroundColor: Colors
                    .blue, // Ganti dengan warna sesuai dengan tema aplikasi Anda
                colorText: Colors.white, // Warna teks putih
                borderRadius: 8, // Menambahkan radius pada sudut Snackbar
                margin: EdgeInsets.all(12), // Menambahkan margin
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16), // Menambahkan padding
              );
              // Arahkan ke halaman login setelah menunjukkan snackbar
              Get.toNamed(RouteName.login);
            } else {
              // Jika token ada, izinkan akses halaman lainnya
              controller.onItemTapped(index);
            }
          },
        ),
      ),
    );
  }
}
