import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../providers/connection.dart';
import 'package:markopi/service/token_storage.dart';

class LikeForumService {
  static const String _endpoint = '/forum/';

  static Future<Response> likeForum(int forumId) async {
    final String? token = await TokenStorage.getToken();
    final Dio dio = Dio();

    final url = Connection.buildUrl('$_endpoint$forumId/like');

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            Headers.contentTypeHeader: 'application/json',
            Headers.acceptHeader: 'application/json',
          },
        ),
      );

      debugPrint('Like Forum response: ${response.data}');

      return response;
    } on DioException catch (e) {
      debugPrint('DioException: ${e.response?.data}');
      throw Exception('Gagal melakukan like forum: ${e.message}');
    }
  }

  static Future<Response> unlikeForum(int forumId) async {
    final String? token = await TokenStorage.getToken();
    final Dio dio = Dio();

    final url = Connection.buildUrl('$_endpoint$forumId/dislike');

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            Headers.contentTypeHeader: 'application/json',
            Headers.acceptHeader: 'application/json',
          },
        ),
      );

      debugPrint('Unlike Forum response: ${response.data}');

      return response;
    } on DioException catch (e) {
      debugPrint('DioException: ${e.response?.data}');
      throw Exception('Gagal melakukan unlike forum: ${e.message}');
    }
  }

  static Future<Map<String, dynamic>> getForumLikeAndDislikeCount(int forumId) async {
    final String? token = await TokenStorage.getToken();
    final Dio dio = Dio();

    final url = Connection.buildUrl('$_endpoint$forumId/likes/count');

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Gagal mendapatkan jumlah like');
    }
  }

  static Future<int> checkIfLiked(int forumId) async {
    final String? token = await TokenStorage.getToken();
    final Dio dio = Dio();

    final url = Connection.buildUrl('$_endpoint$forumId/is-liked');

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['like_status'];
    } else {
      throw Exception('Gagal mendapatkan jumlah like');
    }
  }
}
