import 'package:flutter/material.dart';
import 'package:markopi/service/toko_service.dart';
import 'package:markopi/models/toko.dart';
import 'package:url_launcher/url_launcher.dart';

class TokoKopiPage extends StatelessWidget {
  const TokoKopiPage({super.key});

  Future<void> _launchMapsUrl(String locationUrl) async {
    final url = 'https://www.google.com/maps?q=${Uri.encodeComponent(locationUrl)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    // Refresh data toko
    await Future.delayed(const Duration(seconds: 2));
    TokoService.getAllTokos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Toko Kopi'),
      ),
      body: FutureBuilder<List<Toko>?>(
        future: TokoService.getAllTokos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Cek koneksi internet anda'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data toko'));
          } else {
            List<Toko> tokos = snapshot.data!;

            return RefreshIndicator(
              onRefresh: () => _refreshData(context), // Fungsi refresh
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tokos.length,
                itemBuilder: (context, index) {
                  final toko = tokos[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _launchMapsUrl(toko.lokasi),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            toko.fotoToko.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      toko.fotoToko,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 120,
                                          height: 120,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.wifi_off, size: 40, color: Colors.grey),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Gagal memuat\ngambar',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.store,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Nama Toko: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: toko.namaToko),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Rute Link Lokasi: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: toko.lokasi),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Jam Operasional: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: toko.jamOperasional),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
