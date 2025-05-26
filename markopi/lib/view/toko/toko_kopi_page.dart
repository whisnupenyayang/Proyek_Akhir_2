import 'package:flutter/material.dart';
import 'package:markopi/service/toko_service.dart';
import 'package:markopi/models/toko.dart';
import 'package:url_launcher/url_launcher.dart'; // Package untuk membuka URL

class TokoKopiPage extends StatelessWidget {
  const TokoKopiPage({super.key});

  // Fungsi untuk membuka URL peta
  Future<void> _launchMapsUrl(String locationUrl) async {
    // Membuat URL Google Maps dari alamat toko
    final url = 'https://www.google.com/maps?q=${Uri.encodeComponent(locationUrl)}';

    if (await canLaunch(url)) {
      await launch(url); // Membuka URL peta di browser atau aplikasi peta
    } else {
      throw 'Could not launch $url'; // Jika gagal membuka URL
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Toko Kopi'),
      ),
      body: FutureBuilder<List<Toko>?>( // Mengambil data toko
        future: TokoService.getAllTokos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data toko'));
          } else {
            List<Toko> tokos = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tokos.length,
              itemBuilder: (context, index) {
                final toko = tokos[index];

                return GestureDetector(
                  onTap: () {
                    _launchMapsUrl(toko.lokasi); // Menangani tap untuk membuka peta
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      leading: toko.fotoToko.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                toko.fotoToko,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.store,
                              size: 80,
                              color: Colors.grey,
                            ),
                      title: Text(
                        toko.namaToko,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            toko.lokasi,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Jam Operasional: ${toko.jamOperasional}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.location_on,
                        size: 36,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
