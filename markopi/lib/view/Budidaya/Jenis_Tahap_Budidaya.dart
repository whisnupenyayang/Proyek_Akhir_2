import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Budidaya_Controller.dart';
import 'package:markopi/controllers/Kegiatan_Controller.dart';
import 'package:markopi/routes/route_name.dart';
import './Jenis_Tahap_Budidaya_Detail.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JenisTahapBudidayaView extends StatefulWidget {
  @override
  State<JenisTahapBudidayaView> createState() => _JenisTahapBudidayaViewState();
}

class _JenisTahapBudidayaViewState extends State<JenisTahapBudidayaView> {
  final KegiatanController kegiatanC = Get.put(KegiatanController());
  final BudidayaController budidayaC = Get.put(BudidayaController());
  int? id;

  @override
  void initState() {
    super.initState();
    try {
      id = int.parse(Get.parameters['id']!);
    } catch (e) {
      id = null;
    }

    if (id != null) {
      budidayaC.jenisTahapBudidayaList.clear();
      kegiatanC.fetchJenisTahapanKegiatan(id!);
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
        if (kegiatanC.jenisTahapKegiatanList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: kegiatanC.jenisTahapKegiatanList.length,
          itemBuilder: (context, index) {
            final item = kegiatanC.jenisTahapKegiatanList[index];
            return GestureDetector(
              onTap: () {
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
                      // Gambar tanpa warna hitam dan proporsional
                      Container(
                        width: MediaQuery.of(context).size.width * 3 / 8,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://markopi.d4trpl-itdel.id/storage/${item.url_gambar}', // Gantilah dengan URL hosting Anda
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      // Teks judul
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
                                  item.judul ?? 'Tanpa Judul',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 30),
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
