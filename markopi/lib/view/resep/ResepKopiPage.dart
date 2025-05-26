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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar resep dengan ukuran lebih besar
              resep.gambarResep.isNotEmpty
                  ? Image.network(
                      resep.gambarResep,
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 200,
                    ),
              const SizedBox(height: 24),
              // Nama resep dengan font size besar
              Text(
                resep.namaResep,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Deskripsi resep dengan font size lebih besar
              Text(
                resep.deskripsiResep,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
