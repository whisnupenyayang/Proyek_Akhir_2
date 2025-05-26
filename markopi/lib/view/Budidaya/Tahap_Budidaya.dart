import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Budidaya_Controller.dart';
import 'package:markopi/controllers/Kegiatan_Controller.dart';
import 'package:markopi/routes/route_name.dart';
import './Jenis_Tahap_Budidaya.dart';
import '';

class TipeBudidaya extends StatefulWidget {
  @override
  _TipeBudidayaState createState() => _TipeBudidayaState();
}

class _TipeBudidayaState extends State<TipeBudidaya> {
  final KegiatanController kegiatanC = Get.put(KegiatanController());
  String? jenis_kopi;
  String? kegiatan;

  @override
  void initState() {
    super.initState();

    jenis_kopi = Get.parameters['jenis_kopi'];
    kegiatan = Get.parameters['kegiatan'];

    if (jenis_kopi != null && kegiatan != null) {
      print(jenis_kopi);
      kegiatanC.fetchKegiatan(kegiatan!, jenis_kopi!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jenis_kopi == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("ID tidak valid")),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF2696D6),
      appBar: AppBar(
        backgroundColor: Color(0xFF2696D6),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(jenis_kopi!, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF2696D6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Obx(() {
                if (kegiatanC.tahapanKegiatanList.isEmpty) {
                  return Center(
                    child: Text(
                      "Data tidak tersedia.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: kegiatanC.tahapanKegiatanList.length,
                  itemBuilder: (context, i) {
                    final tahapKegiatan = kegiatanC.tahapanKegiatanList[i];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.kegiatan +
                            '/$kegiatan/$jenis_kopi/jenistahapankegiatan/${tahapKegiatan.id}');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(Icons.park,
                                  size: 30, color: Color(0xFF142B44)),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                tahapKegiatan.nama_tahapan,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color(0xFF142B44),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
