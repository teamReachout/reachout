import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/widgets/appbar.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:reachout/widgets/post.dart';

class UserFeed extends StatefulWidget {
  final User currentUser;

  UserFeed({this.currentUser});
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  List<Post> timelinePosts;
  List<String> followingList = [];

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    // print(snapshot.documents.length);
    List<Post> posts =
        snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      timelinePosts = posts;
    });
  }

  buildTimeline() {
    if (timelinePosts == null) {
      return LoadingIndicator();
    } else if (timelinePosts.isEmpty) {
      return Text('Follow Users');
    } else {
      return Column(
        children: [
          ...timelinePosts,
        ],
      );
    }
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        child: Appbar(),
        preferredSize: const Size.fromHeight(44),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              showTimeline(),
            ]),
          )
        ],
      ),
    );
  }

  Widget showTimeline() {
    return Container(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
      ),
    );
  }
}
