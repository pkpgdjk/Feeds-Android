import 'package:feeds/model/comment.dart';
import 'package:feeds/model/post.dart';
import 'package:feeds/model/user.dart';
import 'package:feeds/service/post.dart';
import 'package:feeds/utils.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post}) : super(key: key);

  Post post;

  @override
  State<StatefulWidget> createState() {
    return _PostDetailState();
  }
}

class _PostDetailState extends State<PostDetail>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  List<Comment> _comments = [];

  final txtComent = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> raw =
        await PostService().fetchComments(widget.post.id);
    if (this.mounted) {
      setState(() {
        _comments = raw.map((item) => Comment.fromJson(item)).toList();
        isLoading = false;
      });
    }
  }

  void comment() async {
    setState(() {
      isLoading = true;
    });
    var author = await User().getAuthor();
    FocusScope.of(context).unfocus();

    await PostService()
        .comment(txtComent.text, author, widget.post.id.toString());

    await fetch();
    txtComent.clear();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Feeds"),
        ),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Card(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Text(
                            Utils().timeago(widget.post.date),
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 50),
                        child: Text(
                          widget.post.content,
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
                Divider(),
                Opacity(
                    opacity: 0.6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                            "ความคิดเห็น...(${_comments.length.toString()})"))),
                Divider(),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: txtComent,
                    decoration: InputDecoration(
                      hintText: "แสดงความคิดเห็น...",
                      suffixIcon: IconButton(
                        onPressed: () => comment(),
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
                Divider(),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.pink),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: ListView.builder(
                            padding: EdgeInsets.all(5.0),
                            itemCount:
                                _comments.length, //calculating length ist
                            itemBuilder: (BuildContext context, int index) {
                              return _commentBuilder(context, index, _comments);
                            })),
              ],
            ),
          )),
        ));
  }

  Widget _commentBuilder(
      BuildContext context, int index, List<Comment> comment) {
    return InkWell(
      child: InkWell(
          onTap: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "${comment[index].symbol} : ${comment[index].content}",
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                  child: Text(
                    Utils().timeago(comment[index].date),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontStyle: FontStyle.italic),
                  )),
              Divider()
            ],
          )),
      // onTap: () => MaterialPageRoute(
      //     builder: (context) =>
      //         SecondRoute(id: posts.getId(index), name: posts.getName(index))),
    );
  }
}
