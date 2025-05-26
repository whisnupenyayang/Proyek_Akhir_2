import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';
import 'package:markopi/routes/route_name.dart';

class UserPengepulView extends StatefulWidget {
  const UserPengepulView({super.key});

  @override
  State<UserPengepulView> createState() => _UserPengepulViewState();
}

class _UserPengepulViewState extends State<UserPengepulView> {
  final PengepulController pengepulC = Get.put(PengepulController());

  void initState() {
    super.initState();
    pengepulC.fetchPengepulByUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data pengepul anda'),
      ),
      body: Obx(
        () {
          if (pengepulC.pengepul.isEmpty) {
            return Center(
              child: Text('tidak ada data pengepul anda'),
            );
          }
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: pengepulC.pengepul.length,
            itemBuilder: (context, index) {
              final item = pengepulC.pengepul[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl:
                            'http://10.0.2.2:8000/storage/budidayaimage/OjPcIQh71iVEIq6A2wk3Z1AuZh73KgFTX9JQOWtP.png',
                        height: 150 +
                            (index % 2) *
                                30, // bikin tinggi gambar sedikit acak
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.nama_toko ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(item.alamat ?? '',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${item.harga}',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(RouteName.pengepul + '/tambahDataPengepul');
        },
        label: Text('Tambah data pengepul anda'),
        backgroundColor: Colors.lightBlue, // Biru muda
        tooltip: 'Tambah Data',
        icon: Icon(Icons.add), // Optional, bisa dihapus jika tidak mau ada ikon
      ),
    );
  }
}
