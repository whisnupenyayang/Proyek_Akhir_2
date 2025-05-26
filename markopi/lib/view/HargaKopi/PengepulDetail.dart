import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markopi/controllers/PengajuanTransaksi_Controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';
import 'package:markopi/routes/route_name.dart';

class DetailPengepuldanPetani extends StatefulWidget {
  @override
  _DetailPengepuldanPetaniState createState() =>
      _DetailPengepuldanPetaniState();
}

class _DetailPengepuldanPetaniState extends State<DetailPengepuldanPetani> {
  final PengajuanTransaksiController pengajuanC =
      Get.put(PengajuanTransaksiController());

  final PengepulController pengepulC = Get.put(PengepulController());

  String? role;
  @override
  void initState() {
    super.initState();
    final idStr = Get.parameters['id'];
    final id = int.tryParse(idStr ?? '') ?? 1;

    pengepulC.fetcPengepulDetail(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pengepul"),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          var item = pengepulC.detailPengepul.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Pengepul dengan AspectRatio dan BoxFit.contain
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.nama_gambar != null && item.nama_gambar.isNotEmpty
                    ? AspectRatio(
                        aspectRatio: 16 / 9, // sesuaikan rasio sesuai kebutuhan
                        child: CachedNetworkImage(
                          imageUrl: Connection.buildImageUrl(item.url_gambar),
                          width: double.infinity,
                          fit: BoxFit.contain, // agar gambar tidak terpotong
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.store, size: 50, color: Colors.grey[600]),
                      ),
              ),
              SizedBox(height: 16),

              // Nama Toko & Harga
              Text(
                item.nama_toko ?? 'Nama Toko',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.coffee, color: Colors.brown),
                  SizedBox(width: 8),
                  Text(
                    '${item.jenis_kopi ?? 'Jenis Kopi Tidak Tersedia'}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Rp. ${item.harga}/Kg',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              // Informasi Detail
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Detail',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                          'Alamat', item.alamat ?? 'Alamat tidak tersedia'),
                      Divider(),
                      _buildInfoRow('Nomor Telepon',
                          item.nomor_telepon ?? 'Nomor tidak tersedia'),
                      Divider(),
                      _buildInfoRow('Jenis Kopi', item.jenis_kopi ?? 'Tidak tersedia'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Hubungi
              Text(
                'Hubungi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.chat),
                label: Text("Buka WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: () async {
                  String phoneNumber = item.nomor_telepon ?? '';
                  phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
                  if (phoneNumber.startsWith('0')) {
                    phoneNumber = '62${phoneNumber.substring(1)}';
                  } else if (!phoneNumber.startsWith('62')) {
                    phoneNumber = '62$phoneNumber';
                  }
                  final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
                  try {
                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(whatsappUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('WhatsApp tidak tersedia di perangkat ini')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Terjadi kesalahan: $e')));
                  }
                },
              ),

              SizedBox(height: 24),

              // Tombol Hapus
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _deletePengepul(item.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: Text("Hapus Toko"),
                ),
              ),
              SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk menghapus pengepul
  void _deletePengepul(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Pengepul"),
          content: Text("Apakah Anda yakin ingin menghapus pengepul ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Menutup dialog
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                pengepulC.deletePengepul(id); // Panggil deletePengepul
                Get.back(); // Menutup dialog setelah berhasil
                Get.back(); // Kembali ke halaman sebelumnya
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}
