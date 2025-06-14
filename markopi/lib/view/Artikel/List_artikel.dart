import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Artikel_Controller.dart';
import 'package:markopi/controllers/SearchArtikelController.dart';
import 'package:markopi/models/Artikel_Model.dart';
import 'package:markopi/view/artikel/detail_artikel.dart';

class ListArtikel extends StatefulWidget {
  @override
  _ListArtikelState createState() => _ListArtikelState();
}

class _ListArtikelState extends State<ListArtikel> {
  final ArtikelController artikelC = Get.put(ArtikelController());
  final SearchArtikelController searchC = Get.put(SearchArtikelController());

  @override
  void initState() {
    super.initState();
    ever(artikelC.artikel, (_) {
      searchC.setArtikel(artikelC.artikel);
    });

    Future.delayed(Duration.zero, () {
      artikelC.fetchArtikel();
    });
  }

  Future<void> _refreshData() async {
    await artikelC.fetchArtikel();
    searchC.setArtikel(artikelC.artikel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Artikel",
          style: TextStyle(color: Colors.white), // Set AppBar title text to white
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade500, // Set AppBar color to blue.shade500
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => searchC.filterArtikel(value),
              decoration: InputDecoration(
                hintText: "Cari",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (artikelC.isLoading.value) {
                return Center(child: CircularProgressIndicator(color: Colors.blue.shade500)); // Set loading indicator color
              }
              if (artikelC.errorMessage.isNotEmpty) {
                return Center(child: Text('Error: ${artikelC.errorMessage.value}'));
              }
              if (searchC.filteredArtikel.isEmpty) {
                return Center(child: Text('Data artikel kosong'));
              }

              return RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                  itemCount: searchC.filteredArtikel.length,
                  itemBuilder: (context, index) {
                    final Artikel artikel = searchC.filteredArtikel[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (artikel.imageUrls.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    artikel.imageUrls.first.startsWith('http')
                                        ? artikel.imageUrls.first
                                        : 'http://192.168.150.244:8000/images/${artikel.imageUrls.first}',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 180,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image, size: 50),
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 8),
                              Text(
                                artikel.judulArtikel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                artikel.isiArtikel,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => DetailArtikel(artikel: artikel));
                                },
                                child: Text(
                                  "Lihat Selengkapnya",
                                  style: TextStyle(
                                    color: const Color(0xFF2196F3), // Set text color to blue.shade500
                                    fontWeight: FontWeight.w500,
                                  ),
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
            }),
          ),
        ],
      ),
    );
  }
}
