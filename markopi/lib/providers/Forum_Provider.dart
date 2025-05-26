import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:flutter/foundation.dart';

class ForumProvider extends GetConnect {
  final String url = '/forum'; // API endpoint for forums
  
  // Method for posting a new forum (with multipart for images)
  Future<Response> postForum({
    required String token,
    required String judulForum,
    required String deskripsiForum,
    String? imagePath,
  }) async {
    debugPrint('ForumProvider: postForum called with title: $judulForum');
    final String apiUrl = Connection.buildUrl(url);
    debugPrint('ForumProvider: API URL for posting forum: $apiUrl');
    
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';
    
    // Add text fields
    request.fields['title'] = judulForum;
    request.fields['deskripsi'] = deskripsiForum;

    
    // Add image file if provided
    if (imagePath != null && imagePath.isNotEmpty) {
      debugPrint('ForumProvider: Adding image from path: $imagePath');
      try {
        final mimeType = lookupMimeType(imagePath) ?? 'application/octet-stream';
        debugPrint('ForumProvider: Image MIME type: $mimeType');
        
        request.files.add(await http.MultipartFile.fromPath(
          'gambar', // Field name for the image in the API
          imagePath,
          contentType: MediaType.parse(mimeType),
        ));
        debugPrint('ForumProvider: Image file added to request');
      } catch (e) {
        debugPrint('ForumProvider: Error adding image to request: $e');
      }
    }
    
    try {
      debugPrint('ForumProvider: Sending forum creation request');
      // Send the multipart request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      debugPrint('ForumProvider: Forum creation response status: ${response.statusCode}');
      debugPrint('ForumProvider: Forum creation response body: ${response.body}');
      
      // Convert the response to GetConnect's Response format
      return Response(
        statusCode: response.statusCode,
        body: jsonDecode(response.body),
        statusText: response.statusCode == 200 || response.statusCode == 201
            ? 'Success'
            : 'Failed',
      );
    } catch (e, stackTrace) {
      debugPrint('ForumProvider: Error during forum creation: $e');
      debugPrint('ForumProvider: Stack trace: $stackTrace');
      // Handle any errors during the request
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
  
  // Fetch forum list with pagination
  Future<Response> getForum(int page, String? token) async {
    final String apiUrl = Connection.buildUrl('$url?limit=5&page=$page');
    debugPrint('ForumProvider: Getting forums with URL: $apiUrl');
    
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        debugPrint('ForumProvider: Using authorization token');
      } else {
        debugPrint('ForumProvider: No token provided for getForum');
      }
      
      debugPrint('ForumProvider: Sending GET request for forums');
      final response = await get(apiUrl, headers: headers);
      
      debugPrint('ForumProvider: Forums response status: ${response.statusCode}');
      if (response.status.hasError) {
        debugPrint('ForumProvider: Error getting forums: ${response.statusText}');
      } else {
        debugPrint('ForumProvider: Forums retrieved successfully');
        if (kDebugMode) {
          final bodyType = response.body.runtimeType;
          debugPrint('ForumProvider: Response body type: $bodyType');
          
          // Log partial response body (limited to avoid overwhelming logs)
          final bodyPreview = response.body.toString();
          final limitedPreview = bodyPreview.length > 500 
              ? bodyPreview.substring(0, 500) + '...(truncated)'
              : bodyPreview;
          debugPrint('ForumProvider: Response body preview: $limitedPreview');
        }
      }
      
      return response;
    } catch (e, stackTrace) {
      debugPrint('ForumProvider: Exception in getForum: $e');
      debugPrint('ForumProvider: Stack trace: $stackTrace');
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
  
  // Fetch forum detail by ID
  Future<Response> getForumDetail(int id, String? token) async {
    final String apiUrl = Connection.buildUrl('$url/$id');
    
    try {
      Map<String, String> headers = {
        "Content-type" : "application/json",
        "Accept" : "application/json"
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint('ForumProvider: No token provided for getForumDetail');
      }
  
      final response = await get(apiUrl, headers: headers);
      
      debugPrint('ForumProvider: Forum detail response status: ${response.statusCode}');
      if (response.status.hasError) {
        debugPrint('ForumProvider: Error getting forum detail: ${response.statusText}');
      } else {
        debugPrint('ForumProvider: Forum detail retrieved successfully');
      }
      
      return response;
    } catch (e, stackTrace) {
      debugPrint('ForumProvider: Exception in getForumDetail: $e');
      debugPrint('ForumProvider: Stack trace: $stackTrace');
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
  
  // Fetch comments for a forum
  Future<Response> getKomentar(int id) async {
    final String apiUrl = Connection.buildUrl('/forumKomen/$id');
    debugPrint('ForumProvider: Getting comments with URL: $apiUrl');
    
    try {
      debugPrint('ForumProvider: Sending GET request for comments');
      final response = await get(apiUrl);
      
      debugPrint('ForumProvider: Comments response status: ${response.statusCode}');
      if (response.status.hasError) {
        debugPrint('ForumProvider: Error getting comments: ${response.statusText}');
      } else {
        debugPrint('ForumProvider: Comments retrieved successfully');
      }
      
      return response;
    } catch (e, stackTrace) {
      debugPrint('ForumProvider: Exception in getKomentar: $e');
      debugPrint('ForumProvider: Stack trace: $stackTrace');
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
  
  // Post comment to a forum
  Future<Response> postKomentar(String komentar, String? token, int forum_id) async {
    final String apiUrl = Connection.buildUrl('/forum/$forum_id/komentar');
    debugPrint('ForumProvider: Posting comment to URL: $apiUrl');
    
    try {
      final body = json.encode({"komentar": komentar, "forum_id": forum_id});
      debugPrint('ForumProvider: Comment request body: $body');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept' : 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        debugPrint('ForumProvider: Using authorization token for comment');
      } else {
        debugPrint('ForumProvider: No token provided for postKomentar!');
      }
      
      final response = await post(apiUrl, body, headers: headers);
      
      debugPrint('ForumProvider: Comment response status: ${response.statusCode}');
      if (response.status.hasError) {
        debugPrint('ForumProvider: Error posting comment: ${response.statusText}');
        debugPrint('ForumProvider: Error response body: ${response.body}');
      } else {
        debugPrint('ForumProvider: Comment posted successfully');
      }
      
      return response;
    } catch (e, stackTrace) {
      debugPrint('ForumProvider: Exception in postKomentar: $e');
      debugPrint('ForumProvider: Stack trace: $stackTrace');
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
}