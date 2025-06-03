import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Budidaya_Controller.dart';
import 'package:markopi/controllers/Kegiatan_Controller.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JenisTahapBudidayaView extends StatefulWidget {
  @override
  State<JenisTahapBudidayaView> createState() => _JenisTahapBudidayaViewState();
}

class _JenisTahapBudidayaViewState extends State<JenisTahapBudidayaView> {
  final KegiatanController kegiatanC = Get.put(KegiatanController()); // Controller untuk mengambil data kegiatan
  final BudidayaController budidayaC = Get.put(BudidayaController()); // Controller untuk mengambil data budidaya
  int? id; // Menyimpan ID tahap budidaya

  @override
  void initState() {
    super.initState();
    try {
      id = int.parse(Get.parameters['id']!); // Mengambil ID dari URL
    } catch (e) {
      id = null; // Jika ID tidak ada atau tidak valid
    }

    if (id != null) {
      budidayaC.jenisTahapBudidayaList.clear(); // Membersihkan data sebelumnya
      kegiatanC.fetchJenisTahapanKegiatan(id!); // Memanggil fungsi untuk mengambil data tahap kegiatan
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menampilkan halaman error jika ID tidak ditemukan
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("ID tidak valid")), // Pesan error
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Jenis Tahap Budidaya"), // Judul halaman
      ),
      body: Obx(() {
        // Menunggu data kegiatan yang akan ditampilkan
        if (kegiatanC.jenisTahapKegiatanList.isEmpty) {
          return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading jika data kosong
        }

        return ListView.builder(
          itemCount: kegiatanC.jenisTahapKegiatanList.length, // Menampilkan daftar tahap kegiatan
          itemBuilder: (context, index) {
            final item = kegiatanC.jenisTahapKegiatanList[index]; // Mengambil data tiap item

            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman detail tahap kegiatan
                Get.toNamed(RouteName.kegiatan +
                    '/jenistahapanbudidaya/detail/${item.id}');
              },
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Menampilkan gambar tahap kegiatan
                      Container(
                        width: MediaQuery.of(context).size.width * 3 / 8,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://markopi.d4trpl-itdel.id/storage/${item.url_gambar}', // URL gambar
                            fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi penuh
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()), // Menampilkan indikator loading saat gambar dimuat
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error), // Menampilkan ikon error jika gagal memuat gambar
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      // Menampilkan teks judul tahap kegiatan
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  item.judul ?? 'Tanpa Judul', // Judul kegiatan atau "Tanpa Judul" jika tidak ada
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis, // Menampilkan teks dengan batasan dan overflow
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 30), // Ikon untuk menunjukkan navigasi
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
