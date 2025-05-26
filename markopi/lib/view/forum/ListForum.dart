import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Forum_Controller.dart';
import 'package:markopi/providers/Connection.dart';

class ListForum extends StatelessWidget {
  final ForumController forumController = Get.put(ForumController());

  ListForum() {
    debugPrint('ListForum: Widget constructed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forum Komunitas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade500,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          debugPrint('ListForum: Pull-to-refresh triggered');
          return forumController.refreshForum();
        },
        child: Obx(() {
          debugPrint(
              'ListForum: Obx rebuild triggered, isLoading=${forumController.isLoading.value}, forumCount=${forumController.forum.length}');

          // Always show search field
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari forum...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    forumController.searchForum(value);
                  },
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (forumController.isLoading.value &&
                        forumController.forum.isEmpty) {
                      debugPrint(
                          'ListForum: Showing loading indicator (first load)');
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (forumController.forum.isEmpty &&
                        !forumController.isLoading.value) {
                      debugPrint('ListForum: No forums available to display');
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Tidak ada forum tersedia'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                forumController.refreshForum();
                              },
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          if (forumController.hasMore.value &&
                              !forumController.isLoading.value) {
                            forumController.loadMore();
                            return true;
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: forumController.forum.length +
                            (forumController.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < forumController.forum.length) {
                            final forum = forumController.forum[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: const Color(
                                  0xFFE5F2FF), // Warna latar belakang seperti pada gambar
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  ;
                                  Get.toNamed('/forum-detail/${forum.id}');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header: Nama pengguna dan tanggal
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/iklan1.png'), // Ganti dengan avatar sesuai data user jika ada
                                            radius: 14,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                forum.user.namaLengkap,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                forum.tanggal,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Gambar forum
                                      forum.imageUrls.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                Connection.buildImageUrl(
                                                    "storage/${forum.imageUrls.first}"),
                                                height: 160,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      const SizedBox(height: 12),

                                      // Judul forum
                                      Text(
                                        forum.judulForum,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // Deskripsi forum
                                      Text(
                                        forum.deskripsiForum,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            debugPrint(
                                'ListForum: Showing bottom loading indicator, isLoading=${forumController.isLoading.value}');
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: forumController.isLoading.value
                                    ? Column(
                                        children: [
                                          const CircularProgressIndicator(),
                                          const SizedBox(height: 8),
                                          Text('Memuat data...',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
          onPressed: () {
            Get.toNamed('/add-forum');
          },
          child: const Text(
            "Tanya Di Komunitas",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
