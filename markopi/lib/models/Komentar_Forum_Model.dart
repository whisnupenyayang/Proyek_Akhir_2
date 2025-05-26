import 'package:markopi/models/User_Model.dart'; // Pastikan User diimpor

class KomentarForum {
  final int id;
  final String komentar;
  final int forumId;
  final int userId;
  final User user; // Pastikan User diimpor dan didefinisikan

  KomentarForum({
    required this.id,
    required this.komentar,
    required this.forumId,
    required this.userId,
    required this.user,
  });

  factory KomentarForum.fromJson(Map<String, dynamic> json) {
    return KomentarForum(
      id: json['id_forum_komentars'],
      komentar: json['komentar'] ?? '',
      forumId: json['forum_id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']), // Pastikan User di-parse dengan benar
    );
  }
}
