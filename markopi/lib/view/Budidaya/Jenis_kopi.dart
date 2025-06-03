import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/routes/route_name.dart';

class BudidayaView extends StatefulWidget {
  @override
  _BudidayaViewState createState() => _BudidayaViewState();
}

class _BudidayaViewState extends State<BudidayaView> {
  late String kegiatan; // Menyimpan parameter kegiatan yang diterima dari route
  final List<String> kopiList = ['Arabika', 'Robusta']; // Daftar jenis kopi yang akan ditampilkan

  @override
  void initState() {
    super.initState();
    kegiatan = Get.parameters['kegiatan'] ?? ''; // Mengambil parameter kegiatan dari URL
    print('Kegiatan: $kegiatan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kegiatan), // Menampilkan nama kegiatan di AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberikan padding pada konten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Jenis Kopi', // Judul utama
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: kopiList.length, // Menentukan jumlah item dalam daftar
                itemBuilder: (context, i) {
                  final jenisKopi = kopiList[i]; // Mengambil jenis kopi dari daftar
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jenisKopi, // Menampilkan jenis kopi
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          onTap: () => Get.toNamed(
                              '${RouteName.kegiatan}/$kegiatan/$jenisKopi'), // Navigasi ke halaman berdasarkan jenis kopi
                          borderRadius: BorderRadius.circular(10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Container(
                                  height: 172,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/icon/$jenisKopi.jpg'), // Menampilkan gambar berdasarkan jenis kopi
                                      fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi penuh
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Color(0xff142B44), // Warna latar bawah gambar
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: Text(
                                      'Mulai', // Teks tombol untuk memulai
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
