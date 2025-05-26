import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:get/get.dart';

class KopiPage extends StatefulWidget {
  @override
  _KopiPageState createState() => _KopiPageState();
}

class _KopiPageState extends State<KopiPage> {
  bool isMyShop = false;  // Initially show all stores (not just my shop)
  final PengepulController pengepulC = Get.put(PengepulController());

  @override
  void initState() {
    super.initState();
    pengepulC.fetchPengepul();  // Fetch all stores initially
    pengepulC.fetchPengepulByUser();  // Fetch user's stores as well
  }

  Future<void> _refreshData() async {
    if (isMyShop) {
      await pengepulC.fetchPengepulByUser();  // Refresh user's store data
    } else {
      await pengepulC.fetchPengepul();  // Refresh all store data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isMyShop ? 'Toko Milik Saya' : 'Semua Toko Pengepul'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ayo!! Temukan harga terbaik untuk Kopi Anda.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Toggle buttons for "Toko Milik Saya" and "Semua Toko"
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isMyShop = true;
                      });
                    },
                    child: Text(
                      'Toko Milik Saya',
                      style: TextStyle(
                        color: isMyShop ? Colors.brown : Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isMyShop = false;
                      });
                    },
                    child: Text(
                      'Semua Toko',
                      style: TextStyle(
                        color: isMyShop ? Colors.grey : Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPengepulGrid(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteName.pengepul + '/tambah');
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the grid of stores
  Widget _buildPengepulGrid() {
    return Obx(() {
      final pengepulList = isMyShop ? pengepulC.pengepulByUser : pengepulC.pengepul;

      if (pengepulList.isEmpty) {
        return const Center(
          child: Text("Tidak ada data pengepul", style: TextStyle(fontSize: 16)),
        );
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pengepulList.length,
        itemBuilder: (context, index) {
          final item = pengepulList[index];
          return _buildPengepulCard(item);
        },
      );
    });
  }

  Widget _buildPengepulCard(dynamic item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.pengepul + '/detail/${item.id}');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: Connection.buildImageUrl(item.url_gambar),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.brown,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow('Nama Toko:', item.nama_toko ?? '-', isBold: true),
                  _buildInfoRow('Lokasi:', item.alamat ?? '-'),
                  _buildInfoRow(
                    'Harga Beli:',
                    'Rp ${item.harga.toString()}',
                    textColor: Colors.green,
                    isBold: true,
                  ),
                  if (item.jenis_kopi != null && item.jenis_kopi!.isNotEmpty)
                    _buildInfoRow('Jenis Kopi:', item.jenis_kopi!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
