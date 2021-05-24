import 'package:feeds/model/comment.dart';

class Post {
  final int id;
  final String content;
  final String author;
  final List<Comment> comments;
  final int date;

  Post({this.id, this.content, this.author, List<Comment> comments, this.date})
      : this.comments = comments ?? [];

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
        id: json['id'] as int,
        content: json['content'],
        author: json['author'],
        date: json['date'] as int);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'author': author,
        'comments': comments,
        'date': date,
      };
}
