import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:markopi/service/token_storage.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late String? token; // Menyimpan token pengguna yang diambil dari penyimpanan.

  @override
  void initState() {
    super.initState();
    getStorage(); // Memanggil fungsi untuk mengambil token saat halaman dimulai.
  }

  void getStorage() async {
    token = await TokenStorage.getToken(); // Mengambil token yang disimpan.
  }

  // Daftar gambar dan menu yang akan ditampilkan.
  final List<String> imageList = [
    'assets/images/budidaya_baru.jpg',
    'assets/images/panen_baru.jpg',
    'assets/images/pascapanen_baru.jpg',
    'assets/images/resepkopi.jpg',
    'assets/images/toko.png',
    'assets/images/laporan_baru.jpg',
  ];

  final List<String> menuList = [
    'Budidaya',
    'Panen',
    'Pasca_Panen',
    'Resep_Kopi',
    'Toko_Kopi',
    'Laporan',
  ];

  final List<String> labelMenu = [
    'Budidaya',
    'Panen',
    'Pasca Panen',
    'Resep Kopi',
    'Toko Kopi',
    'Laporan',
  ];

  // Menyimpan status apakah menu sedang dipilih atau tidak.
  List<bool> isPressed = List.generate(6, (_) => false);

  // Fungsi untuk menangani ketika menu diklik.
  void _handleTap(int index) async {
  setState(() {
    print('Menu yang dipilih: ${menuList[index]}'); // Menampilkan menu yang dipilih.

    // Menentukan navigasi berdasarkan menu yang dipilih
    if (menuList[index] == 'Toko_Kopi') {
      print('Navigasi ke Toko Kopi');
      Get.toNamed(RouteName.tokoKopi); // Navigasi ke halaman Toko Kopi
    } else if (menuList[index] == 'Resep_Kopi') {
      print('Navigasi ke Resep Kopi');
      Get.toNamed(RouteName.resepKopi); // Navigasi ke halaman Resep Kopi
    } else if (menuList[index] == 'Laporan') {
      print('Navigasi ke Laporan');
      if (token != null) {
        // Jika token ada, menuju ke halaman Laporan
        Get.toNamed(RouteName.laporan);
      } else {
        // Jika token tidak ada, arahkan ke halaman login terlebih dahulu
        Get.offAllNamed(RouteName.login);

        // Tampilkan Snackbar setelah beberapa detik
        Future.delayed(Duration(seconds: 1), () {
          Get.snackbar(
            "Anda belum login", // Judul Snackbar
            "Silakan login untuk mengakses halaman laporan", // Pesan Snackbar
            snackPosition: SnackPosition.TOP, // Posisi di atas layar
            backgroundColor: Colors.lightBlueAccent[700]!, // Warna latar belakang abu-abu
            colorText: Colors.white, // Warna teks putih
            borderRadius: 8, // Menambahkan radius pada sudut Snackbar
            margin: EdgeInsets.all(12), // Menambahkan margin
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Menambahkan padding
          );
        });
      }
    } else {
      // Navigasi ke halaman kegiatan berdasarkan pilihan menu
      print('Navigasi ke kegiatan: ${RouteName.kegiatan}/${menuList[index]}');
      Get.toNamed('${RouteName.kegiatan}/${menuList[index]}');
    }
  });
}


  // Fungsi untuk membangun item menu.
  Widget buildMenuItem(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index), // Ketika item menu diklik, jalankan _handleTap.
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Animasi ketika menekan menu.
        width: 100,
        height: 110,
        decoration: BoxDecoration(
          color: isPressed[index] ? Colors.blue[900] : Colors.transparent, // Warna menu saat dipilih.
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10), // Menambahkan sudut melengkung.
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageList[index], // Menampilkan gambar menu.
              width: 50,
              height: 50,
              fit: BoxFit.cover, // Menyesuaikan gambar agar pas di dalam kotak.
            ),
            const SizedBox(height: 8), // Jarak antara gambar dan teks.
            Text(
              labelMenu[index], // Menampilkan label menu.
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14), // Menentukan ukuran teks.
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menampilkan menu dalam dua baris.
    return Container(
      color: Colors.white, // Menentukan latar belakang.
      padding: const EdgeInsets.all(15.0), // Padding di sekitar menu.
      child: Column(
        children: [
          // Baris pertama menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Menyebar menu dalam satu baris.
            children: [
              buildMenuItem(0),
              buildMenuItem(1),
              buildMenuItem(2),
            ],
          ),
          const SizedBox(height: 20), // Jarak antar baris menu.
          // Baris kedua menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildMenuItem(3),
              buildMenuItem(4),
              buildMenuItem(5),
            ],
          ),
        ],
      ),
    );
  }
}
