import 'package:feeds/model/posts_list.dart';
import 'package:feeds/page/new_post.dart';
import 'package:feeds/page/post_detail.dart';
import 'package:feeds/utils.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/post.dart';

void main() {
  runApp(MyApp());
}

PostsListModel postsListModel = PostsListModel();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<PostsListModel>(
        model: postsListModel,
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: Colors.pink.shade200,
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
              title: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          home: MyHomePage(
            title: "Feeds",
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  void newPost(PostsListModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPost()),
    ).whenComplete(() => model.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PostsListModel>(
        builder: (context, child, model) {
      var _isLoading = model.isLoading;
      var _posts = model.posts;
      if (!_isLoading) {
        _controller.forward();
      }

      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.pink),
                      ),
                    )
                  : FadeTransition(
                      opacity: _animation,
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () => newPost(model),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                width: double.maxFinite,
                                height: 100,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Text(
                                        "โพสต์ข้อความ....",
                                        style: TextStyle(
                                            color: Colors.pink.shade200,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              height: 500,
                              width: double.maxFinite,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(5.0),
                                  itemCount:
                                      _posts.length, //calculating length ist
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _postBuilder(context, index, _posts);
                                  }))
                        ],
                      ),
                    )));
    });
  }

  Widget _postBuilder(BuildContext context, int index, List<Post> posts) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: InkWell(
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(post: posts[index]),
                      ),
                    )
                  },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Text(
                        posts[index].content,
                        textAlign: TextAlign.left,
                      )),
                  Container(
                    width: double.maxFinite,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 10, 10),
                        child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              Utils().timeago(posts[index].date),
                              textAlign: TextAlign.right,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ))),
                  ),
                ],
              )),
        ),
      ),
      // onTap: () => MaterialPageRoute(
      //     builder: (context) =>
      //         SecondRoute(id: posts.getId(index), name: posts.getName(index))),
    );
  }
}
