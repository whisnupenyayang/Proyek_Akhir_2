import 'package:flutter/material.dart';
import 'package:markopi/controllers/Artikel_Controller.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart'; // Import pengepul controller
import 'package:markopi/service/token_storage.dart';
import './MainMenu.dart';
import 'package:markopi/models/Artikel_Model.dart';
import 'package:markopi/models/Pengepul_Model.dart'; // Import pengepul model
import 'package:get/get.dart';
import 'package:markopi/view/iklan/iklan_banner.dart';

class BerandaBody extends StatefulWidget {
  const BerandaBody({super.key});

  @override
  State<BerandaBody> createState() => _BerandaBodyState();
}

class _BerandaBodyState extends State<BerandaBody> {
  final ArtikelController artikelC = Get.put(ArtikelController());
  final PengepulController pengepulC = Get.put(PengepulController()); // Instance pengepul controller
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    artikelC.fetchArtikel();
    pengepulC.fetchPengepul(); // Fetch pengepul data
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            MainMenu(),
            SizedBox(height: 30),
            const Text(
              'Harga Rata-rata Kopi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            buildHargaRataRata(), // Display average price
            SizedBox(height: 10),
            IklanBanner(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan harga rata-rata pengepul
  Widget buildHargaRataRata() {
    return Obx(() {
      if (pengepulC.pengepul.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      // Menghitung harga rata-rata
      double totalHarga = 0;
      pengepulC.pengepul.forEach((item) {
        totalHarga += item.harga ?? 0; // Pastikan harga tidak null
      });
      double hargaRataRata = totalHarga / pengepulC.pengepul.length;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Harga Rata-rata: Rp ${hargaRataRata.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
