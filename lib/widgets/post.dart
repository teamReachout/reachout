import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/screens/comments.dart';
import 'package:reachout/screens/profile_page.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  bool showHeart = false;
  int likeCount;
  int commentCount = 0;
  Map likes;
  bool isLiked;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });

  deletePost() async {
    postsRef
        .document(ownerId)
        .collection('userPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    storageRef.child('post_$postId.jpg').delete();

    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection('feedItems')
        .where(
          'postId',
          isEqualTo: postId,
        )
        .getDocuments();

    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot commentSnapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();

    commentSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleDeletePost(BuildContext parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text('Remove this post?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deletePost();
              },
            ),
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        User user = User.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            ),
            child: Text(
              user.firstName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing: isPostOwner
              ? IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => handleDeletePost(context),
                )
              : Text(''),
        );
      },
    );
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection('feedItems')
          .document(postId)
          .get()
          .then(
        (doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        },
      );
    }
  }

  addLikeToActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection('feedItems')
          .document(postId)
          .setData({
        'type': 'like',
        'firstName': currentUser.firstName,
        'usedId': currentUser.id,
        'userProfileImage': currentUser.photoUrl,
        'postId': postId,
        'mediaUrl': mediaUrl,
        'timestamp': timestamp,
      });
    }
  }

  handleLikePost() {
    bool _isLiked = likes[currentUserId] == true;
    if (_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: mediaUrl,
          ),
        ],
      ),
    );
  }

  showComments(
    BuildContext context, {
    String postId,
    String ownerId,
    String mediaUrl,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return Comments(
          postId: postId,
          postOwnerId: ownerId,
          postMediaUrl: mediaUrl,
          getCommentCount: getCommentCount,
        );
      }),
    );
  }

  addComment() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      commentsRef.document(postId).collection('comments').add({
        'firstname': currentUser.firstName,
        'comment': commentController.text,
        'timestamp': timestamp,
        'avatarUrl': currentUser.photoUrl,
        'userId': currentUser.id,
      });
      bool isNotPostOwner = ownerId != currentUser.id;
      if (isNotPostOwner) {
        activityFeedRef.document(ownerId).collection('feedItems').add({
          'type': 'comment',
          'commentData': commentController.text,
          'firstname': currentUser.firstName,
          'lastname': currentUser.lastName,
          'usedId': currentUser.id,
          'userProfileImage': currentUser.photoUrl,
          'postId': postId,
          'mediaUrl': mediaUrl,
          'timestamp': timestamp,
        });
      }
      commentController.clear();
      FocusScope.of(context).unfocus();
    }
    getCommentCount();
  }

  buildPostFooter(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: handleLikePost,
                child: Icon(
                  isLiked ? MdiIcons.thumbUp : MdiIcons.thumbUpOutline,
                  size: 28,
                ),
              ),
              GestureDetector(
                onTap: () => showComments(
                  context,
                  postId: postId,
                  ownerId: ownerId,
                  mediaUrl: mediaUrl,
                ),
                child: Icon(
                  MdiIcons.commentTextMultipleOutline,
                  size: 28,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  MdiIcons.shareAllOutline,
                  size: 28,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  MdiIcons.contactsOutline, // Reachout button
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 25,
          endIndent: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 20,
                top: 2,
                bottom: 2,
              ),
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$likeCount',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      Icon(
                        Icons.thumb_up,
                        color: Colors.green,
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      Text(
                        '$commentCount',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      Icon(
                        Icons.comment,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 6,
            bottom: 6,
          ),
          child: mediaUrl.trim() == ''
              ? null
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '$username',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(' '),
                    Expanded(
                      child: ReadMoreText(
                        description,
                        trimLines: 2,
                        colorClickableText: Colors.grey,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '...Show more',
                        trimExpandedText: ' show less',
                      ),
                    ),
                  ],
                ),
        ),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              bottom: 2.0,
            ),
            child: Container(
              height: 45,
              width: 250,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autocorrect: true,
                  cursorColor: Theme.of(context).primaryColor,
                  controller: commentController,
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim() == '') {
                      return "";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: addComment,
            icon: Icon(Icons.send),
          ),
        ),
      ],
    );
  }

  getCommentCount() async {
    QuerySnapshot comments = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    setState(() {
      commentCount = comments.documents.length;
    });
  }

  buildDescription() {
    return ListTile(
      title: Text(
        description,
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        mediaUrl.trim() == '' ? buildDescription() : buildPostImage(),
        buildPostFooter(context),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              timeago.format(
                DateTime.now(),
              ),
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Divider(
            color: Color.fromRGBO(217, 217, 217, 1),
            thickness: 10,
          ),
        ),
      ],
    );
  }
}
