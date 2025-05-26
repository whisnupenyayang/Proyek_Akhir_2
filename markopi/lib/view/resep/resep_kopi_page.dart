import 'package:flutter/material.dart';
import 'package:markopi/service/resep_service.dart';
import 'package:markopi/models/resep.dart';
import 'package:markopi/view/resep/ResepKopiPage.dart';

class ResepKopiPage extends StatelessWidget {
  const ResepKopiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Kopi'),
      ),
      body: FutureBuilder<List<Resep>>(
        future: ResepService.getAllReseps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada resep kopi ditemukan.'),
            );
          } else {
            final reseps = snapshot.data!;
            return ListView.builder(
              itemCount: reseps.length,
              itemBuilder: (context, index) {
                final resep = reseps[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResepDetailPage(resep: resep),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Gambar lebih besar
                          resep.gambarResep.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    resep.gambarResep,
                                    width: 100,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 60);
                                    },
                                  ),
                                )
                              : const Icon(Icons.image_not_supported, size: 60),
                          const SizedBox(width: 16),
                          // Text dengan font lebih besar dan ekspansi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  resep.namaResep,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  resep.deskripsiResep.length > 120
                                      ? resep.deskripsiResep.substring(0, 120) + '...'
                                      : resep.deskripsiResep,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
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
