import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Forum_Controller.dart';
import 'package:markopi/controllers/like_forum.dart';
import 'package:markopi/providers/Connection.dart';

class ForumKomentar extends StatefulWidget {
  const ForumKomentar({super.key});

  @override
  State<ForumKomentar> createState() => _ForumKomentarState();
}

class _ForumKomentarState extends State<ForumKomentar> {
  bool isSending = false;

  final ForumController forumC = Get.put(ForumController());
  final TextEditingController _komentar = TextEditingController();
  final LikeForumController _likeForumController =
      Get.put(LikeForumController(int.parse(Get.parameters['id']!)));

  int? id;

  @override
  void initState() {
    super.initState();
    final idParam = Get.parameters['id'];
    id = int.tryParse(idParam ?? '');
    debugPrint("$id");

    if (id != null) {
      forumC.komentarForum.clear();
      forumC.forumDetail.value = null;
      forumC.fetchForumDetail(id!);
      forumC.fetchKomentar(id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("ID tidak Valid")),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Detail forum',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          // Header forum
          Obx(() {
            final forum = forumC.forumDetail.value;
            if (forum == null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 20,
                            // Bisa pakai foto profil: backgroundImage: NetworkImage(forum.user.avatarUrl)
                          ),
                          SizedBox(width: 10),
                          Text(
                            forum.user.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            forum.imageUrls.isNotEmpty
                                ? Image.network(
                                    Connection.buildImageUrl(
                                        "storage/${forum.imageUrls.first}"),
                                    height: 80,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 80,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    forum.judulForum,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    forum.deskripsiForum,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    forum.tanggal,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() => Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    _likeForumController
                                                                .likeStatus
                                                                .value ==
                                                            1
                                                        ? Icons
                                                            .thumb_up_alt_rounded
                                                        : Icons
                                                            .thumb_up_outlined,
                                                    color: _likeForumController
                                                                .likeStatus
                                                                .value ==
                                                            1
                                                        ? Colors.blue
                                                        : null,
                                                  ),
                                                  onPressed: () async {
                                                    await _likeForumController
                                                        .likeForum(id!);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    _likeForumController
                                                                .likeStatus
                                                                .value ==
                                                            2
                                                        ? Icons
                                                            .thumb_down_alt_rounded
                                                        : Icons
                                                            .thumb_down_outlined,
                                                    color: _likeForumController
                                                                .likeStatus
                                                                .value ==
                                                            2
                                                        ? Colors.red
                                                        : null,
                                                  ),
                                                  onPressed: () async {
                                                    await _likeForumController
                                                        .dislikeForum(id!);
                                                  },
                                                ),
                                              ],
                                            )),
                                        Obx(() => Row(
                                              children: [
                                                Text(
                                                    "${_likeForumController.likeCount.value} Suka"),
                                                SizedBox(width: 10),
                                                Text(
                                                    "${_likeForumController.dislikeCount.value} Tidak Suka"),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),

          // List komentar
          Expanded(
            child: Obx(() {
              if (forumC.komentarForum.isEmpty) {
                return Center(child: Text("Belum ada komentar"));
              }

              return ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                itemCount: forumC.komentarForum.length,
                itemBuilder: (context, index) {
                  var komentar = forumC.komentarForum[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.lightBlue.shade100,
                          radius: 23,
                          // Bisa pakai foto profil jika ada
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        komentar.userNamaLengkap,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        " - ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        komentar.userRole,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    komentar.komentar.trim(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Input komentar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _komentar,
                        decoration: InputDecoration(
                          hintText: "Tulis komentar...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: isSending
                          ? null
                          : () async {
                              String komentar = _komentar.text.trim();
                              if (komentar.isNotEmpty && id != null) {
                                setState(() => isSending = true);
                                await forumC.buatKomentar(komentar, id!);
                                _komentar.clear();
                                setState(() => isSending = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                      ),
                      child: isSending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
