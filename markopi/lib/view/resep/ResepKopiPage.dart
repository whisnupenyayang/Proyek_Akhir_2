import 'package:flutter/material.dart';
import 'package:markopi/models/resep.dart';

class ResepDetailPage extends StatelessWidget {
  final Resep resep;
  const ResepDetailPage({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          resep.namaResep,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar resep dengan GestureDetector untuk menampilkan gambar dalam tampilan penuh saat di-klik
            resep.gambarResep.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      // Ketika gambar di-klik, buka tampilan gambar penuh
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                            imageUrl: resep.gambarResep,
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      resep.gambarResep,
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                    ),
                  )
                : Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 200,
                    ),
                  ),
            // Konten
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Nama resep
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 28, color: Colors.black),
                      children: [
                        const TextSpan(
                          text: 'Nama Resep: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: resep.namaResep,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Label deskripsi
                  const Text(
                    'Deskripsi Resep:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Isi deskripsi
                  Text(
                    resep.deskripsiResep,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman baru untuk menampilkan gambar dalam tampilan penuh dengan tombol kembali
class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImagePage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
