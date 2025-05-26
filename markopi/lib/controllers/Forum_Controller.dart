import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:markopi/models/Forum_Model.dart';
import 'package:markopi/models/Komentar_Forum_Model.dart';
import 'package:markopi/providers/Forum_Provider.dart';
import 'package:markopi/service/token_storage.dart';
import 'package:flutter/foundation.dart';

class ForumController extends GetxController {
  var forum = <Forum>[].obs;
  var page = 1.obs;
  var isLoading = false.obs;
  RxBool hasMore = true.obs;
  var komentarForum = <KomentarForum>[].obs; // List of comments for a forum
  var forumDetail = Rxn<Forum>(); // Detail of the specific forum
  final forumProvider = ForumProvider();

  @override
  void onInit() {
    super.onInit();
    debugPrint('ForumController: onInit called');
    fetchForum(); // Load initial data when controller is initialized
  }

  @override
  void onClose() {
    debugPrint('ForumController: onClose called');
    komentarForum.clear();
    super.onClose();
  }

  // Fetching forum list with pagination
  Future<void> fetchForum() async {
    debugPrint('ForumController: fetchForum called, page=${page.value}, isLoading=${isLoading.value}');
    if (isLoading.value) {
      debugPrint('ForumController: Already loading, skipping fetch');
      return; // Prevent multiple simultaneous requests
    }
    
    isLoading.value = true;
    debugPrint('ForumController: Getting token');
    final String? token = await TokenStorage.getToken();
    debugPrint('ForumController: Token ${token != null ? "received" : "not available"}');
    
    try {
      debugPrint('ForumController: Calling API to get forums for page ${page.value}');
      final response = await forumProvider.getForum(page.value, token);
      debugPrint('ForumController: API response status: ${response.statusCode}, text: ${response.statusText}');
      
      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          debugPrint('ForumController: Response body type: ${responseBody.runtimeType}');
          
          // If response body is a string, parse it
          final dynamic parsed = responseBody is String ? jsonDecode(responseBody) : responseBody;
          debugPrint('ForumController: Parsed response: $parsed');
          
          final data = parsed['data'];
          debugPrint('ForumController: Data from response: $data');
          
          if (data is List && data.isNotEmpty) {
            debugPrint('ForumController: Data is a non-empty list of length ${data.length}');
            try {
              final newForums = data.map<Forum>((item) {
                debugPrint('ForumController: Processing forum item: $item');
                return Forum.fromJson(item);
              }).toList();
              
              debugPrint('ForumController: Processed ${newForums.length} new forums');
              
              if (page.value == 1) {
          
                forum.clear(); // Clear only on first page
              }
              
              forum.addAll(newForums);
              page.value++; // Increment page for next fetch
            
              
              hasMore.value = newForums.length >= 5; 
            } catch (e) {
              Get.snackbar('Error', 'Gagal memproses data forum: $e');
            }
          } else {
            debugPrint('ForumController: No forum data available or empty list');
            if (page.value == 1) {
              forum.clear(); // Ensure list is empty if no data on first page
            }
            hasMore.value = false;
          }
        } catch (e, stackTrace) {
          debugPrint('ForumController: Error decoding response: $e');
          debugPrint('ForumController: Stack trace: $stackTrace');
          debugPrint('ForumController: Raw response body: ${response.body}');
          Get.snackbar('Error', 'Gagal mengolah data: $e');
          hasMore.value = false;
        }
      } else {
        debugPrint('ForumController: Error response: ${response.statusCode}, ${response.statusText}');
        debugPrint('ForumController: Error body: ${response.body}');
        Get.snackbar('Error', 'Gagal mengambil data forum: ${response.statusText}');
        hasMore.value = false;
      }
    } catch (e, stackTrace) {
      debugPrint('ForumController: Exception during fetch: $e');
      debugPrint('ForumController: Stack trace: $stackTrace');
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      hasMore.value = false;
    } finally {
      debugPrint('ForumController: Completed fetchForum, setting isLoading to false');
      isLoading.value = false;
    }
  }

  // Load more forums when scrolling
  void loadMore() {
    debugPrint('ForumController: loadMore called, isLoading=${isLoading.value}, hasMore=${hasMore.value}');
    if (!isLoading.value && hasMore.value) {
      fetchForum();
    } else {
      debugPrint('ForumController: Skipping loadMore because ${isLoading.value ? "still loading" : "no more data"}');
    }
  }

  // Refreshing the forum list (pull to refresh functionality)
  Future<void> refreshForum() async {
    debugPrint('ForumController: refreshForum called');
    page.value = 1; // Reset to first page
    hasMore.value = true;
    await fetchForum();
  }

  // Fetching comments for a specific forum based on forum_id
  Future<void> fetchKomentar(int id) async {
    debugPrint('ForumController: fetchKomentar called for forum ID $id');
    try {
      final response = await forumProvider.getKomentar(id);
      debugPrint('ForumController: Komentar API response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          final dynamic parsed = responseBody is String ? jsonDecode(responseBody) : responseBody;
          debugPrint('ForumController: Parsed komentar response: $parsed');
          
          final data = parsed['data'];
          debugPrint('ForumController: Komentar data: $data');
          
          if (data is List) {
            final comments = data.map<KomentarForum>((item) {
              debugPrint('ForumController: Processing comment item: $item');
              return KomentarForum.fromJson(item);
            }).toList();
            
            komentarForum.value = comments;
            debugPrint('ForumController: Loaded ${komentarForum.length} comments');
          } else {
            debugPrint('ForumController: No comments available or invalid format');
            komentarForum.value = [];
          }
        } catch (e, stackTrace) {
          debugPrint('ForumController: Error processing comments: $e');
          debugPrint('ForumController: Stack trace: $stackTrace');
          komentarForum.value = [];
          Get.snackbar('Error', 'Gagal memproses data komentar: $e');
        }
      } else {
        debugPrint('ForumController: Error fetching comments: ${response.statusCode}, ${response.statusText}');
        Get.snackbar('Error', 'Gagal mengambil komentar');
      }
    } catch (e, stackTrace) {
      debugPrint('ForumController: Exception during fetchKomentar: $e');
      debugPrint('ForumController: Stack trace: $stackTrace');
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil komentar: $e');
    }
  }

  Future<void> tambahForum(String judul, String description, File image) async {  
    final String? token = await TokenStorage.getToken();
    try {
      if (token == null) {
        Get.snackbar('Error', 'Token tidak tersedia');
        return;
      }
      final response = await forumProvider.postForum(
        token: token,
        judulForum: judul,
        deskripsiForum: description,
        imagePath: image.path,
      );
     
     if (response.statusCode == 200) {
       Get.snackbar("Berhasil", "Pertanyaan Berhasil Di Publish");
     } else {
       Get.snackbar('Error', 'Gagal menambah forum');
     }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah forum: $e');
    }
  }

  // Fetching detailed information for a specific forum by id
  Future<void> fetchForumDetail(int id) async {
    debugPrint('ForumController: fetchForumDetail called for forum ID $id');
    try {
      final String? token = await TokenStorage.getToken();
      debugPrint('ForumController: Token for detail ${token != null ? "received" : "not available"}');
      
      final response = await forumProvider.getForumDetail(id, token);
      debugPrint('ForumController: Detail API response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          final dynamic parsed = responseBody is String ? jsonDecode(responseBody) : responseBody;
          debugPrint('ForumController: Parsed detail response: $parsed');
          
          final data = parsed['data'];
          debugPrint('ForumController: Detail data: $data');
          
          if (data != null) {
            try {
              forumDetail.value = Forum.fromJson(data);
              debugPrint('ForumController: Forum detail loaded successfully');
            } catch (e, stackTrace) {
              debugPrint('ForumController: Error processing forum detail: $e');
              debugPrint('ForumController: Stack trace: $stackTrace');
              forumDetail.value = null;
              Get.snackbar('Error', 'Gagal memproses data forum');
            }
          } else {
            debugPrint('ForumController: Forum detail data is null');
            forumDetail.value = null;
            Get.snackbar('Error', 'Data forum detail kosong');
          }
        } catch (e, stackTrace) {
          debugPrint('ForumController: Error decoding detail response: $e');
          debugPrint('ForumController: Stack trace: $stackTrace');
          forumDetail.value = null;
          Get.snackbar('Error', 'Gagal mengolah data detail: $e');
        }
      } else {
        debugPrint('ForumController: Error fetching forum detail: ${response.statusCode}, ${response.statusText}');
        Get.snackbar('Error', 'Gagal mengambil detail forum');
      }
    } catch (e, stackTrace) {
      debugPrint('ForumController: Exception during fetchForumDetail: $e');
      debugPrint('ForumController: Stack trace: $stackTrace');
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil detail forum: $e');
    }
  }

  // Adding a comment to a forum
  Future<void> buatKomentar(String komentar, int forum_id) async {
    debugPrint('ForumController: buatKomentar called for forum ID $forum_id with comment: $komentar');
    try {
      final String? token = await TokenStorage.getToken();
      if (token == null) {
        debugPrint('ForumController: No token available for commenting');
        Get.snackbar('Error', 'Anda belum login');
        return;
      }
      
      debugPrint('ForumController: Posting comment to API');
      final response = await forumProvider.postKomentar(komentar, token, forum_id);
      debugPrint('ForumController: Comment API response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('ForumController: Comment posted successfully');
        Get.snackbar('Berhasil', 'Komentar berhasil ditambahkan');
        await fetchKomentar(forum_id);
      } else {
        debugPrint('ForumController: Error posting comment: ${response.statusCode}, ${response.statusText}');
        debugPrint('ForumController: Error body: ${response.body}');
        Get.snackbar('Gagal', 'Gagal menambahkan komentar');
      }
    } catch (e, stackTrace) {
      debugPrint('ForumController: Exception during buatKomentar: $e');
      debugPrint('ForumController: Stack trace: $stackTrace');
      Get.snackbar('Error', 'Terjadi kesalahan saat menambahkan komentar: $e');
    }
  }

  // Search forums by title or description
  void searchForum(String value) {
    if (value.isEmpty) {
      // If search is empty, reload the original forum list
      refreshForum();
      return;
    }
    final query = value.toLowerCase();
    final filtered = forum.where((f) =>
      (f.judulForum?.toLowerCase().contains(query) ?? false) ||
      (f.deskripsiForum?.toLowerCase().contains(query) ?? false)
    ).toList();
    forum.value = filtered;
    hasMore.value = false; // Disable load more when searching
  }
}