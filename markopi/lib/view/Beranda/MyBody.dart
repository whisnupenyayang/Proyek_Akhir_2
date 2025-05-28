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
            SizedBox(height: 30),
            
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

      double totalHarga = 0;
      pengepulC.pengepul.forEach((item) {
        totalHarga += item.harga?.toDouble() ?? 0;
      });

      double hargaRataRata = totalHarga / pengepulC.pengepul.length;

      final formattedHarga =
          NumberFormat("#,###", "id_ID").format(hargaRataRata.toInt());

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Harga rata-rata kopi per 1 kg: Rp $formattedHarga',
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
