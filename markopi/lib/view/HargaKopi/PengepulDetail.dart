import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DetailPengepuldanPetani extends StatefulWidget {
  @override
  _DetailPengepuldanPetaniState createState() =>
      _DetailPengepuldanPetaniState();
}

class _DetailPengepuldanPetaniState extends State<DetailPengepuldanPetani> {
  final PengepulController pengepulC = Get.put(PengepulController());

  String? role;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    final idStr = Get.parameters['id'];
    final id = int.tryParse(idStr ?? '') ?? 1;

    pengepulC.fetcPengepulDetail(id);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });

    // Fetch data pengepul milik user untuk mengecek kepemilikan
    if (role == 'pengepul') {
      await pengepulC.fetchPengepulByUser();
      _checkOwnership();
    }
  }

  void _checkOwnership() {
    final currentDetailId = pengepulC.detailPengepul.value.id;
    final userPengepulList = pengepulC.pengepulByUser;

    // Cek apakah detail pengepul yang sedang dilihat ada dalam daftar pengepul milik user
    setState(() {
      isOwner =
          userPengepulList.any((pengepul) => pengepul.id == currentDetailId);
    });
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pengepul"),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          var item = pengepulC.detailPengepul.value;

          // Update ownership check ketika data berubah
          if (role == 'pengepul') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkOwnership();
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Pengepul dengan AspectRatio dan BoxFit.contain
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.nama_gambar != null && item.nama_gambar.isNotEmpty
                    ? GestureDetector(
                        onTap: () => _showFullScreenImage(
                            context, Connection.buildImageUrl(item.url_gambar)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: Connection.buildImageUrl(item.url_gambar),
                            width: double.infinity,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.store,
                            size: 50, color: Colors.grey[600]),
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
                'Rp. ${NumberFormat('#,##0', 'id_ID').format(item.harga)}/Kg', // Use 'id_ID' for Indonesian locale
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),

                      // Alamat sebagai link ke Google Maps
                      item.alamat != null
                          ? GestureDetector(
                              onTap: () {
                                final encodedLocation =
                                    Uri.encodeComponent(item.alamat!);
                                final googleMapsUrl = Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=$encodedLocation');
                                launchUrl(googleMapsUrl,
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Alamat',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item.alamat!,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _buildInfoRow('Alamat', 'Alamat tidak tersedia'),

                      Divider(),
                      _buildInfoRow('Nomor Telepon',
                          item.nomor_telepon ?? 'Nomor tidak tersedia'),
                      Divider(),
                      _buildInfoRow(
                          'Jenis Kopi', item.jenis_kopi ?? 'Tidak tersedia'),
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
                  final Uri whatsappUrl =
                      Uri.parse('https://wa.me/$phoneNumber');
                  try {
                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(whatsappUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'WhatsApp tidak tersedia di perangkat ini')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cek koneksi internet anda')));
                  }
                },
              ),

              SizedBox(height: 24),

              // Tombol Hapus - Hanya tampil jika user adalah pengepul dan pemilik toko
              if (role == 'pengepul' && isOwner)
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
                Get.back();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                pengepulC.deletePengepul(id);
                Get.back();
                Get.back();
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Gagal memuat gambar',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
