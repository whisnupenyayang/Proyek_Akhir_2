import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:markopi/service/User_Storage.dart';
import 'package:markopi/service/User_Storage_Service.dart';
import 'package:markopi/service/token_storage.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60); // Menentukan tinggi AppBar.
}

class _MyAppBarState extends State<MyAppBar> {
  final userStorage = UserStorage(); // Untuk mengakses data pengguna.
  UserModel? _user; // Menyimpan data pengguna yang diambil.

  String? token; // Menyimpan token pengguna yang diambil.
  bool isLoading = true; // Menyimpan status loading.

  @override
  void initState() {
    super.initState();
    _loadToken(); // Memanggil fungsi untuk memuat token saat halaman dimulai.
  }

  // Fungsi untuk mengambil token dan data pengguna.
  Future<void> _loadToken() async {
    final result = await TokenStorage.getToken(); // Mengambil token yang disimpan.
    await userStorage.openBox(); // Membuka penyimpanan data pengguna.
    final user = userStorage.getUser(); // Mengambil data pengguna.
    setState(() {
      _user = user;
      token = result;
      isLoading = false; // Menandakan bahwa data sudah dimuat.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menunggu sampai data selesai dimuat sebelum menampilkan AppBar.
    if (isLoading) return const SizedBox.shrink(); // Menyembunyikan AppBar saat loading.

    return AppBar(
      toolbarHeight: 60, // Menentukan tinggi AppBar.
      titleSpacing: 10,
      backgroundColor: Colors.white, // Warna latar belakang AppBar.
      elevation: 1, // Menambahkan bayangan pada AppBar.
      title: Row(
        children: [
          const Icon(Icons.account_circle, size: 50), // Ikon profil pengguna.
          const SizedBox(width: 12), // Jarak antara ikon dan teks.
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Menyusun teks di tengah.
              crossAxisAlignment: CrossAxisAlignment.start, // Menyusun teks ke kiri.
              children: [
                Text(
                  _user?.namaLengkap ?? 'Pengunjung', // Menampilkan nama pengguna atau 'Pengunjung'.
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_user?.namaLengkap == null) // Jika pengguna belum login.
                  const Text(
                    'Anda belum login', // Pesan jika pengguna belum login.
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          if (token == null) // Jika token belum ada, tampilkan tombol masuk dan register.
            Row(
              spacing: 10,
              children: [
                // Tombol untuk masuk
                InkWell(
                  onTap: () => Get.toNamed(RouteName.login), // Navigasi ke halaman login.
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2696D6), // Warna latar tombol.
                      borderRadius: BorderRadius.circular(8), // Menambahkan sudut melengkung.
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Masuk', // Teks tombol 'Masuk'.
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Tombol untuk register
                InkWell(
                  onTap: () => Get.toNamed(RouteName.register), // Navigasi ke halaman register.
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2696D6), // Warna latar tombol.
                      borderRadius: BorderRadius.circular(8), // Menambahkan sudut melengkung.
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Register', // Teks tombol 'Register'.
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
