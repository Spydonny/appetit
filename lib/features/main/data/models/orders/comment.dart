import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final int? authorUserId;
  final String authorRole;
  final String text;
  final DateTime createdAt;

  const Comment({
    required this.id,
    this.authorUserId,
    required this.authorRole,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorUserId: json['author_user_id'],
      authorRole: json['author_role'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'author_user_id': authorUserId,
    'author_role': authorRole,
    'text': text,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, authorUserId, authorRole, text, createdAt];
}
