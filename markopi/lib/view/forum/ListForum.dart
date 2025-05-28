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
                            debugPrint(
                                'Jumlah gambar: ${forum.imageUrls.length}');
                            debugPrint('Daftar gambar: ${forum.imageUrls}');
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: const Color(0xFFE5F2FF),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: InkWell(
                                onTap: () {
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
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey[700],
                                            ),
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

                                      // Gambar forum dengan indikator halaman
                                      forum.imageUrls.isNotEmpty
                                          ? ForumImageSlider(
                                              imageUrls: forum.imageUrls)
                                          : const SizedBox.shrink(),

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

class ForumImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const ForumImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<ForumImageSlider> createState() => _ForumImageSliderState();
}

class _ForumImageSliderState extends State<ForumImageSlider> {
  late PageController _pageController;
  final RxInt _currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              _currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final imageUrl = widget.imageUrls[index];
              return Image.network(
                Connection.buildImageUrl("storage/$imageUrl"),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Text(
              'Gambar ke-${_currentPage.value + 1} dari ${widget.imageUrls.length}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )),
      ],
    );
  }
}
