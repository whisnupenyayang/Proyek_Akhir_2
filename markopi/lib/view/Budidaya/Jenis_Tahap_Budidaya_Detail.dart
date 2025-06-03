import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Budidaya_Controller.dart';
import 'package:markopi/controllers/Kegiatan_Controller.dart';
import 'package:markopi/models/JenisTahapBudidaya_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markopi/models/JenisTahapKegiatan_Model.dart';

class JenisTahapBudidayDetailView extends StatefulWidget {
  const JenisTahapBudidayDetailView({super.key});

  @override
  State<JenisTahapBudidayDetailView> createState() =>
      _JenisTahapBudidayDetailViewState();
}

class _JenisTahapBudidayDetailViewState
    extends State<JenisTahapBudidayDetailView> {
  final BudidayaController budidayaC = Get.put(BudidayaController());
  final KegiatanController kegiatanC = Get.put(KegiatanController());

  int? id; // Menyimpan ID tahap budidaya

  @override
  void initState() {
    super.initState();
    try {
      id = int.tryParse(Get.parameters['id'] ?? ''); // Mengambil ID dari parameter URL
    } catch (e) {
      id = null; // Jika ID tidak valid, set ID ke null
    }

    if (id != null) {
      kegiatanC.jenisTahapKegiatanDetail.value = JenisTahapKegiatan.empty(); // Inisialisasi data kosong
      kegiatanC.fetchjenisTahapanKegiatanDetail(id!); // Mengambil detail tahap kegiatan berdasarkan ID
    }
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      // Menampilkan error jika ID tidak valid
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("ID tidak valid")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Jenis Tahap Budidaya"), // Judul halaman
      ),
      body: Obx(() {
        final item = kegiatanC.jenisTahapKegiatanDetail.value;

        // Menampilkan indikator loading jika data belum tersedia
        if (item.id == 0) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  item.judul, // Menampilkan judul tahap kegiatan
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 21),
                // Menampilkan gambar menggunakan CachedNetworkImage
                Container(
                  color: Colors.grey,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://markopi.d4trpl-itdel.id/storage/${item.url_gambar}', // URL gambar
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()), // Menampilkan loading saat gambar dimuat
                    errorWidget: (context, url, error) => Icon(Icons.error), // Menampilkan ikon error jika gagal memuat gambar
                  ),
                ),
                SizedBox(height: 14),
                // Menampilkan deskripsi tahap kegiatan
                Text(
                  item.deskripsi ?? '-', // Menampilkan deskripsi atau tanda "-" jika tidak ada deskripsi
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
