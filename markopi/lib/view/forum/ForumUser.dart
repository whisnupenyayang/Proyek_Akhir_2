import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Forum_Controller.dart';
import 'package:markopi/providers/connection.dart';

class ForumUser extends StatefulWidget {
  const ForumUser({super.key});

  @override
  State<ForumUser> createState() => _ForumUserState();
}

class _ForumUserState extends State<ForumUser> {
  final ForumController forumC = Get.put(ForumController());

 @override
  void initState() {
    super.initState();
    // Bersihkan data forum dulu tanpa await
    forumC.forum.clear();
    forumC.forumByUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postingan Anda'),
      ),
      body: Obx(() {
        return forumC.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : forumC.forum.isEmpty
                ? const Center(child: Text('Anda belum memposting apapun.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: forumC.forum.length,
                    itemBuilder: (context, index) {
                      final forum = forumC.forum[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: const Color(0xFFE5F2FF),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header: Nama pengguna, tanggal, dan titik tiga
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
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
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          print('Edit forum: ${forum.id}');
                                        } else if (value == 'hapus') {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Hapus Forum'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus forum ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await forumC
                                                        .hapusForum(forum.id);
                                                    await forumC.forumByUser();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'hapus',
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Gambar forum
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
                    },
                  );
      }),
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
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
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
