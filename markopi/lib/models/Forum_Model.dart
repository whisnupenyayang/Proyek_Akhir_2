import 'package:flutter/material.dart';
import 'package:markopi/models/user_model.dart';
import 'package:intl/intl.dart';

class Forum {
  final int id;
  final String judulForum;
  final String deskripsiForum;
  final String tanggal;
  final List<String> imageUrls;
  final User user;
  final int userId;

  Forum({
    required this.id,
    required this.judulForum,
    required this.deskripsiForum,
    required this.tanggal,
    required this.imageUrls,
    required this.userId,
    required this.user,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    List<dynamic> images = json['images'] ?? [];
    List<String> imageUrls = images
        .map((image) {
          if (image is Map && image.containsKey('gambar')) {
            return image['gambar'] as String;
          }
          return '';
        })
        .where((url) => url.isNotEmpty)
        .toList();

    DateTime createdAt = DateTime.parse(json['created_at']);
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    final formattedDate = formatter.format(createdAt);
    return Forum(
      id: json['id_forums'],
      judulForum: json['title'] ?? '',
      deskripsiForum: json['deskripsi'] ?? '',
      tanggal: formattedDate,
      imageUrls: imageUrls,
      userId: json['user_id'],
      user: User.fromJson(json['user']),
    );
  }
}
