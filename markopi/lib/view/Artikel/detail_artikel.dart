import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markopi/models/Artikel_Model.dart';

class DetailArtikel extends StatelessWidget {
  final Artikel artikel;

  const DetailArtikel({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
if (artikel.imageUrls.isNotEmpty) {
  imageUrl = artikel.imageUrls.first; // langsung pakai URL lengkap dari API
}


    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Artikel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artikel.judulArtikel,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  artikel.isiArtikel,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
