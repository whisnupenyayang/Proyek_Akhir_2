import 'package:flutter/material.dart';
import 'package:markopi/service/resep_service.dart';
import 'package:markopi/models/resep.dart';
import 'package:markopi/view/resep/ResepKopiPage.dart';
import 'dart:io'; // Tambahan untuk menangani error koneksi

class ResepKopiPage extends StatelessWidget {
  const ResepKopiPage({super.key});

  Future<void> _refreshData(BuildContext context) async {
    // Ini akan memanggil ulang data resep
    await Future.delayed(const Duration(seconds: 1));
    // Memanggil getAllReseps() lagi untuk memperbarui data
    // Anda dapat menyesuaikan ini jika perlu.
    ResepService.getAllReseps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resep Kopi'),
      ),
      body: FutureBuilder<List<Resep>>(
        future: ResepService.getAllReseps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (snapshot.error is SocketException) {
              return const Center(
                child: Text(
                  'Periksa koneksi internet Anda.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Periksa koneksi internet anda',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada resep kopi ditemukan.',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final reseps = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () => _refreshData(context), // Fungsi refresh
              child: ListView.builder(
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            resep.gambarResep.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      resep.gambarResep,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image,
                                            size: 40, color: Colors.grey);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported,
                                    size: 100, color: Colors.grey),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.black),
                                      children: [
                                        const TextSpan(
                                          text: 'Nama Resep: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: resep.namaResep),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black87),
                                      children: [
                                        const TextSpan(
                                          text: 'Deskripsi Resep: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: resep.deskripsiResep.length > 50
                                              ? resep.deskripsiResep.substring(0, 50) + '...'
                                              : resep.deskripsiResep,
                                        ),
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