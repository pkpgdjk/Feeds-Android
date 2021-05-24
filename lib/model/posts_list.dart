import 'package:feeds/service/post.dart';
import 'package:flutter/material.dart';

import 'package:feeds/model/post.dart';
import 'package:scoped_model/scoped_model.dart';

class PostsListModel extends Model {
  List<Post> get posts => _posts.toList();
  bool get isLoading => _isLoading;

  bool _isLoading = false;
  List<Post> _posts = [];

  static PostsListModel of(BuildContext context) =>
      ScopedModel.of<PostsListModel>(context);

  @override
  void addListener(listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    _isLoading = true;
    fetch();
    notifyListeners();
  }

  void fetch() async {
    List<Map<String, dynamic>> raw = await PostService().fetchPosts();
    this._posts = raw.map((item) => Post.fromJson(item)).toList();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void removeListener(listener) {
    super.removeListener(listener);
    print("remove listner called");
  }
}
