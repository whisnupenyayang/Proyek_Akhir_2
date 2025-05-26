import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:markopi/service/like_forum.dart';

class LikeForumController extends GetxController {
  final int forumId;
  RxInt likeStatus = 0.obs;
  RxInt likeCount = 0.obs;
  RxInt dislikeCount = 0.obs;

  LikeForumController(this.forumId);

  @override
  void onInit() {
    super.onInit();
    checkIfLiked(forumId);
    getLikeAndDislikeCount(forumId);
  }

  Future<void> checkIfLiked(int forumId) async {
    try {
      int liked = await LikeForumService.checkIfLiked(forumId);
      likeStatus.value = liked;
    } catch (e) {
      debugPrint("Gagal memeriksa status like: $e");
    }
  }

  Future<void> likeForum(int forumId) async {
    try {
      Response response = await LikeForumService.likeForum(forumId);

      if (response.statusCode == 200) {
        debugPrint("Forum berhasil di-like");
        likeStatus.value = int.parse(response.data['data']['like']);
        await getLikeAndDislikeCount(forumId);
      } else {
        debugPrint("Gagal like forum: ${response.data}");
      }
    } catch (e) {
      debugPrint("Error saat like forum: $e");
      rethrow;
    }
  }

  Future<void> dislikeForum(int forumId) async {
    try {
      Response response = await LikeForumService.unlikeForum(forumId);

      if (response.statusCode == 200) {
        debugPrint("Forum berhasil di-dislike");
        likeStatus.value = int.parse(response.data['data']['like']);
        await getLikeAndDislikeCount(forumId);
      } else {
        debugPrint("Gagal unlike forum: ${response.data}");
      }
    } catch (e) {
      debugPrint("Error saat unlike forum: $e");
      rethrow;
    }
  }

  Future<void> getLikeAndDislikeCount(int forumId) async {
    try {
      final response =
          await LikeForumService.getForumLikeAndDislikeCount(forumId);
      likeCount.value = response['like_count'];
      dislikeCount.value = response['dislike_count'];
    } catch (e) {
      debugPrint("Gagal mengambil jumlah like: $e");
      rethrow;
    }
  }
}
