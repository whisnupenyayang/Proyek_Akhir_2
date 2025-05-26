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
    final BottomNavController controller = Get.put(BottomNavController());

    return Scaffold(
      body: Obx(() {
        // Ganti tampilan berdasarkan index yang dipilih
        switch (controller.selectedIndex.value) {
          case 0:
            return Beranda();
          case 1:
            return ListForum();
          case 2:
            return KopiPage();
          case 3:
            return ListArtikel();
          case 4:
            return ProfileView();
          default:
            return Beranda();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
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
          selectedItemColor: const Color(0xFF297CBB),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) async {
            final token = await TokenStorage.getToken();
            if (index == 0) {
              // Selalu izinkan akses ke Beranda
              controller.onItemTapped(index);
            } else if (token == null) {
              // Kalau bukan index 0 dan token null, arahkan ke login
              Get.toNamed(RouteName.login);
            } else {
              // Kalau token ada, izinkan akses
              controller.onItemTapped(index);
            }
          },
        ),
      ),
    );
  }
}
