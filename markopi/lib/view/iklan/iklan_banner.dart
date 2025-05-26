import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markopi/service/iklan_service.dart';
import 'package:markopi/models/iklan.dart';
import 'package:url_launcher/url_launcher.dart';

class IklanBanner extends StatefulWidget {
  const IklanBanner({super.key});

  @override
  State<IklanBanner> createState() => _IklanBannerState();
}

class _IklanBannerState extends State<IklanBanner> {
  late Future<List<Iklan>> _iklanList;

  @override
  void initState() {
    super.initState();
    _iklanList = IklanService.getAllIklan();
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return; // jangan coba buka jika kosong
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Bisa diganti dengan toast/snackbar untuk UX lebih baik
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Temukkan Kebutuhan tanaman anda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: FutureBuilder<List<Iklan>>(
            future: _iklanList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data iklan.'));
              } else {
                final iklanList = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: iklanList.length,
                  itemBuilder: (context, index) {
                    final iklan = iklanList[index];
                    return GestureDetector(
                      onTap: () => _launchURL(iklan.link),
                      child: Container(
                        width: 300,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              iklan.gambar.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: iklan.gambar,
                                      placeholder: (context, url) =>
                                          const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Center(child: Icon(Icons.broken_image, size: 50)),
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(child: Icon(Icons.store, size: 50)),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    iklan.judulIklan,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
        ),
      ],
    );
  }
}
