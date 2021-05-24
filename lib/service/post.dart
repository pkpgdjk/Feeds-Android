import 'package:feeds/model/comment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService {
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(Uri.parse(
        'https://feeds-api.herokuapp.com/posts?_sort=date&_order=desc'));

    if (response.statusCode == 200) {
      var raw = jsonDecode(response.body);
      return raw != null ? List.from(raw) : [];
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> post(String content, String author) async {
    final response = await http.post(
      Uri.parse("https://feeds-api.herokuapp.com/posts"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "content": content,
        "author": author,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create new post');
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(int postsId) async {
    final response = await http.get(
        Uri.parse("https://feeds-api.herokuapp.com/comments?postId=$postsId"));

    if (response.statusCode == 200) {
      var raw = jsonDecode(response.body);
      return raw != null ? List.from(raw) : [];
    } else {
      throw Exception('Failed to load comment');
    }
  }

  Future<Map<String, dynamic>> comment(
      String content, String author, String postsId) async {
    final response = await http.post(
      Uri.parse("https://feeds-api.herokuapp.com/comments"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "content": content,
        "author": author,
        "postId": int.parse(postsId),
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to comment');
    }
  }
}
