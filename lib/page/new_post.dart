import 'package:feeds/model/user.dart';
import 'package:feeds/service/post.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class NewPost extends StatefulWidget {
  NewPost();

  @override
  State<StatefulWidget> createState() {
    return _NewPostState();
  }
}

class _NewPostState extends State<NewPost> {
  final txtPostContent = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void onPost() async {
    setState(() {
      isLoading = true;
    });
    var author = await User().getAuthor();
    await PostService().post(txtPostContent.text, author);

    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("สร้างโพสต์ใหม่"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    onPost();
                  },
                  child: Icon(
                    Icons.check,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: Alignment.topCenter,
            child: isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
                  )
                : TextFormField(
                    controller: txtPostContent,
                    minLines:
                        6, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'เขียนโพสต์....'),
                  )));
  }
}
