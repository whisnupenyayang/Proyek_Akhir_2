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

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      _launchMapsUrl(toko.lokasi);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          toko.fotoToko.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    toko.fotoToko,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.store,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  toko.namaToko,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  toko.lokasi,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Jam Operasional: ${toko.jamOperasional}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
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
            );
          }
        },
      ),
    );
  }
}
