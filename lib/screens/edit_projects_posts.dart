import 'package:flutter/material.dart';
import 'package:reachout/screens/project_post_add.dart';

class EditProjectsPosts extends StatefulWidget {
  final String projectId;
  final List<String> posts;
  EditProjectsPosts({this.projectId, this.posts});
  @override
  _EditProjectsPostsState createState() => _EditProjectsPostsState();
}

class _EditProjectsPostsState extends State<EditProjectsPosts> {
  addPost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProjectPostAdd(
          projectId: widget.projectId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (ctx, i) {
          return ListTile(
            title: Text('Post number: $i'),
            leading: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.posts[i]),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPost,
        child: Icon(Icons.add),
      ),
    );
  }
}
