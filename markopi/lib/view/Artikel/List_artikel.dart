import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Artikel_Controller.dart';
import 'package:markopi/controllers/SearchArtikelController.dart';
import 'package:markopi/models/Artikel_Model.dart';
import 'package:markopi/view/artikel/detail_artikel.dart';

class ListArtikel extends StatefulWidget {
  @override
  _ListArtikelState createState() => _ListArtikelState();
}

class _ListArtikelState extends State<ListArtikel> {
  final ArtikelController artikelC = Get.put(ArtikelController()); // Mengakses controller artikel
  final SearchArtikelController searchC = Get.put(SearchArtikelController()); // Mengakses controller pencarian artikel

  @override
  void initState() {
    super.initState();
    // Mendengarkan perubahan artikel dan mengirimkan data ke controller pencarian
    ever(artikelC.artikel, (_) {
      searchC.setArtikel(artikelC.artikel);
    });

    // Memanggil fungsi untuk mengambil data artikel saat halaman pertama kali dibuka
    Future.delayed(Duration.zero, () {
      artikelC.fetchArtikel(); // Fungsi untuk mengambil data artikel
    });
  }

  // Fungsi untuk melakukan refresh data artikel
  Future<void> _refreshData() async {
    await artikelC.fetchArtikel(); // Mengambil data artikel kembali
    searchC.setArtikel(artikelC.artikel); // Mengupdate data pencarian artikel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artikel"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Kolom pencarian artikel
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => searchC.filterArtikel(value), // Fungsi untuk mencari artikel berdasarkan input
              decoration: InputDecoration(
                hintText: "Cari",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Menampilkan daftar artikel
          Expanded(
            child: Obx(() {
              if (artikelC.isLoading.value) {
                return Center(child: CircularProgressIndicator()); // Menampilkan loading saat data dimuat
              }
              if (artikelC.errorMessage.isNotEmpty) {
                return Center(child: Text('Error: ${artikelC.errorMessage.value}')); // Menampilkan pesan error
              }
              if (searchC.filteredArtikel.isEmpty) {
                return Center(child: Text('Data artikel kosong')); // Jika tidak ada artikel ditemukan
              }

              return RefreshIndicator(
                onRefresh: _refreshData, // Fungsi untuk melakukan refresh artikel
                child: ListView.builder(
                  itemCount: searchC.filteredArtikel.length, // Menghitung jumlah artikel yang ditampilkan
                  itemBuilder: (context, index) {
                    final Artikel artikel = searchC.filteredArtikel[index]; // Mengambil artikel untuk ditampilkan

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menampilkan gambar artikel jika ada
                              if (artikel.imageUrls.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    artikel.imageUrls.first.startsWith('http')
                                        ? artikel.imageUrls.first
                                        : 'http://192.168.150.244:8000/images/${artikel.imageUrls.first}',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 180,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.broken_image, size: 50), // Menampilkan ikon error jika gambar gagal dimuat
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 8),
                              Text(
                                artikel.judulArtikel, // Menampilkan judul artikel
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                artikel.isiArtikel, // Menampilkan ringkasan artikel
                                style: TextStyle(fontSize: 14),
                                maxLines: 2, // Membatasi panjang teks hanya 2 baris
                                overflow: TextOverflow.ellipsis, // Menampilkan ellipsis jika teks lebih panjang dari 2 baris
                              ),
                              SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  // Menavigasi ke halaman detail artikel saat ditekan
                                  Get.to(() => DetailArtikel(artikel: artikel));
                                },
                                child: Text(
                                  "Lihat Selengkapnya", // Teks untuk membuka artikel lebih lengkap
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
