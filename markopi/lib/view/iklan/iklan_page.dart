import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markopi/service/iklan_service.dart';
import 'package:markopi/models/iklan.dart';
import 'package:url_launcher/url_launcher.dart';

class IklanPage extends StatefulWidget {
  const IklanPage({Key? key}) : super(key: key);

  @override
  State<IklanPage> createState() => _IklanPageState();
}

class _IklanPageState extends State<IklanPage> {
  late Future<List<Iklan>> _iklanList;

  @override
  void initState() {
    super.initState();
    _iklanList = IklanService.getAllIklan();
  }

  // Fungsi untuk membuka URL
  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Iklan')),
      body: FutureBuilder<List<Iklan>>(
        future: _iklanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada iklan.'));
          } else {
            final iklanList = snapshot.data!;
            return ListView.builder(
              itemCount: iklanList.length,
              itemBuilder: (context, index) {
                final iklan = iklanList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: iklan.gambar.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: iklan.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(iklan.judulIklan),
                    onTap: () => _launchURL(iklan.link), // Menjalankan link saat di-tap
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
