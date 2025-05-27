class KomentarForum {
  final int id;
  final String komentar;
  final int forumId;
  final int userId;
  final String userNamaLengkap;
  final String userUsername;
  final String userRole;

  KomentarForum({
    required this.id,
    required this.komentar,
    required this.forumId,
    required this.userId,
    required this.userNamaLengkap,
    required this.userUsername,
    required this.userRole,
  });

  factory KomentarForum.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return KomentarForum(
      id: json['id_forum_komentars'],
      komentar: json['komentar'],
      forumId: json['forum_id'],
      userId: json['user_id'],
      userNamaLengkap: user['nama_lengkap'] ?? '',
      userUsername: user['username'] ?? '',
      userRole: user['role'] ?? '',
    );
  }
}
