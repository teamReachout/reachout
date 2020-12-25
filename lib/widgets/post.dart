import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/screens/comments.dart';
import 'package:reachout/screens/profile_page.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

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
  String reachoutMessage;
  bool showHeart = false;
  int likeCount;
  int commentCount = 0;
  Map likes;
  bool isLiked;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _reachoutKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  String reachoutAns1;
  String reachoutAns2;
  String reachoutAns3;
  String reachoutQ1 = 'Why are you reaching out?';
  String reachoutQ2 = 'What is your current market share?';
  String reachoutQ3 = 'Why is it worth my time?';
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

  final customInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
  );

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
          return LoadingIndicator();
        }
        User user = User.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      profileId: ownerId,
                      onSignedOut: null,
                    ),
                  ),
                ),
                child: Text(
                  user.firstName,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
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
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 2,
                bottom: 6,
              ),
              child: mediaUrl.trim() == ''
                  ? null
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
          ],
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

  buildPostImage(var data) {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8.0, 0, 12),
        child: Container(
          width: data.width,
          height: data.height * 0.5,
          // decoration: BoxDecoration(boxShadow: kElevationToShadow[3]),
          child: CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.cover,
          ),
        ),
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

  Widget reachoutForm() {
    return Form(
      key: _reachoutKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(3, 3, 0, 4),
            child: Text(reachoutQ1),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.trim() == '') {
                return "";
              }
              return null;
            },
            onSaved: (value) {
              reachoutAns1 = value;
            },
            maxLines: 5,
            minLines: 3,
            autocorrect: true,
            maxLength: 200,
            decoration: customInputDecoration,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(3, 3, 0, 4),
            child: Text(reachoutQ2),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.trim() == '') {
                return "";
              }
              return null;
            },
            onSaved: (value) {
              reachoutAns2 = value;
            },
            maxLines: 5,
            minLines: 3,
            autocorrect: true,
            maxLength: 200,
            decoration: customInputDecoration,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(3, 3, 0, 4),
            child: Text(reachoutQ3),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.trim() == '') {
                return "";
              }
              return null;
            },
            onSaved: (value) {
              reachoutAns3 = value;
            },
            maxLines: 5,
            minLines: 3,
            autocorrect: true,
            maxLength: 200,
            decoration:
                customInputDecoration, //created at the starting of the file
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.black),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                  ),
                  onPressed: reachout,
                  child: Text(
                    'SAVE',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.black),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                  ),
                  onPressed: leaveReachout,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleReachout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ReachOut Form'.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 20,
                letterSpacing: 0.7,
              )),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 1,
                    child: reachoutForm(),
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  leaveReachout() {
    _reachoutKey.currentState.reset();
    Navigator.of(context).pop();
  }

  reachout() {
    _reachoutKey.currentState.save();
    print(reachoutAns1);
    bool isValid = _reachoutKey.currentState.validate();
    if (isValid) {
      reachoutMessage = 'This is a Reachout message\n\n';
      String textMessage = reachoutMessage +
          reachoutQ1.toUpperCase() +
          ':\n' +
          reachoutAns1 +
          '\n\n' +
          reachoutQ2.toUpperCase() +
          ':\n' +
          reachoutAns2 +
          '\n\n' +
          reachoutQ3.toUpperCase() +
          ':\n' +
          reachoutAns3;
      messagesRef
          .document(currentUser.id)
          .collection('userChats')
          .document(ownerId)
          .collection('userMessages')
          .add({
        'sender': currentUser.id,
        'text': textMessage,
        'receiver': ownerId,
        'time': FieldValue.serverTimestamp(),
      });
      messagesRef
          .document(ownerId)
          .collection('userChats')
          .document(currentUser.id)
          .collection('userMessages')
          .add({
        'sender': currentUser.id,
        'text': textMessage,
        'receiver': ownerId,
        'time': FieldValue.serverTimestamp(),
      });
      leaveReachout();
    }
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
                onTap: () => handleReachout(context),
                child: Text(
                  'REACHOUT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
          child: Divider(
            color: Colors.black,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 20,
                top: 2,
                bottom: 8,
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
    var deviceData = MediaQuery.of(context).size;
    isLiked = (likes[currentUserId] == true);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
      child: Card(
        elevation: 0.5,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildPostHeader(),
            mediaUrl.trim() == ''
                ? buildDescription()
                : buildPostImage(deviceData),
            buildPostFooter(context),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
