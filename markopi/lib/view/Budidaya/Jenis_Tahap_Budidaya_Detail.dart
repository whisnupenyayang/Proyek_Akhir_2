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

  int? id;

  @override
  void initState() {
    super.initState();
    try {
      print('owkw');
      id = int.tryParse(Get.parameters['id'] ?? '');
    } catch (e) {
      print('owkw');
      id = null;
    }

    if (id != null) {
      // budidayaC.jenisTahapBudidayaDetail.value =
      //     budidayaC.jenisTahapBudidayaDetail.value = JenisTahapBudidaya.empty();
      kegiatanC.jenisTahapKegiatanDetail.value = JenisTahapKegiatan.empty();
      kegiatanC.fetchjenisTahapanKegiatanDetail(id!);
      // budidayaC.fetchJenisTahapBudidayaDetail(id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("ID tidak valid")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Jenis Tahap Budidaya"),
      ),
      body: Obx(() {
        final item = kegiatanC.jenisTahapKegiatanDetail.value;

        // loading state
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
                  item.judul,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 21),
                Container(
                  color: Colors.grey,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://markopi.d4trpl-itdel.id/storage/${item.url_gambar}',
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  item.deskripsi ?? '-',
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
