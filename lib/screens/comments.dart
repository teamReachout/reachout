import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;
  final Function getCommentCount;

  Comments({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
    this.getCommentCount,
  });
  @override
  CommentsState createState() => CommentsState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  buildComments() {
    return StreamBuilder(
      stream: commentsRef
          .document(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }
        List<Comment> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      commentsRef.document(postId).collection('comments').add({
        'firstname': currentUser.firstName,
        'comment': commentController.text,
        'timestamp': timestamp,
        'avatarUrl': currentUser.photoUrl,
        'userId': currentUser.id,
      });
      bool isNotPostOwner = postOwnerId != currentUser.id;
      if (isNotPostOwner) {
        activityFeedRef.document(postOwnerId).collection('feedItems').add({
          'type': 'comment',
          'commentData': commentController.text,
          'firstname': currentUser.firstName,
          'lastname': currentUser.lastName,
          'usedId': currentUser.id,
          'userProfileImage': currentUser.photoUrl,
          'postId': postId,
          'mediaUrl': postMediaUrl,
          'timestamp': timestamp,
        });
      }
      commentController.clear();
      FocusScope.of(context).unfocus();
    }
    widget.getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: Form(
              key: _formKey,
              child: TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Write a comment...',
                ),
                validator: (value) {
                  if (value == null || value.trim() == '') {
                    return "";
                  }
                  return null;
                },
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              child: Text('Post'),
              borderSide: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toDate(),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
