import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import untuk format ribuan
import 'package:markopi/controllers/Artikel_Controller.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';
import 'package:markopi/service/Role_storage.dart';
import 'package:markopi/service/token_storage.dart';
import './MainMenu.dart';
import 'package:markopi/models/Artikel_Model.dart';
import 'package:markopi/models/Pengepul_Model.dart';
import 'package:markopi/view/iklan/iklan_banner.dart';

class BerandaBody extends StatefulWidget {
  const BerandaBody({super.key});

  @override
  State<BerandaBody> createState() => _BerandaBodyState();
}

class _BerandaBodyState extends State<BerandaBody> {
  final ArtikelController artikelC = Get.put(ArtikelController());
  final PengepulController pengepulC = Get.put(PengepulController());

  bool isLoading = true;
  String? token;
  String? role;

  @override
  void initState() {
    super.initState();
    print('test');
    _loadRole();

    artikelC.fetchArtikel();
    pengepulC.fetchPengepul();
  }

  void _loadRole() async {
    String? storedRole = await RoleStorage.getRole();
    setState(() {
      role = storedRole;
      print(role);
    });
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
            buildHargaRataRata(),
            SizedBox(height: 10),
            IklanBanner(),
          ],
        ),
      ),
    );
  }

  Widget buildHargaRataRata() {
  return Obx(() {
    if (pengepulC.pengepul.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // Filter berdasarkan jenis kopi
    final arabikaList = pengepulC.pengepul
        .where((item) => item.jenis_kopi?.toLowerCase() == 'arabika')
        .toList();
    final robustaList = pengepulC.pengepul
        .where((item) => item.jenis_kopi?.toLowerCase() == 'robusta')
        .toList();

    // Hitung rata-rata
    double avgArabika = arabikaList.isNotEmpty
        ? arabikaList.map((e) => e.harga?.toDouble() ?? 0).reduce((a, b) => a + b) / arabikaList.length
        : 0;
    double avgRobusta = robustaList.isNotEmpty
        ? robustaList.map((e) => e.harga?.toDouble() ?? 0).reduce((a, b) => a + b) / robustaList.length
        : 0;

    final hargaArabika = NumberFormat("#,###", "id_ID").format(avgArabika.toInt());
    final hargaRobusta = NumberFormat("#,###", "id_ID").format(avgRobusta.toInt());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFD4ECFF),
          ),
          child: Text(
            'Harga Pasaran Kopi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kopi Arabika',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp$hargaArabika/Kg',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kopi Robusta',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp$hargaRobusta/Kg',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  });
}




}
