import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reachout/screens/chat_app.dart';
import 'package:reachout/screens/upload.dart';
import 'package:reachout/screens/user_feed.dart';
import 'screens/profile_page.dart';
import 'models/users.dart';

final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final tagsRef = Firestore.instance.collection('tags');
final timelineRef = Firestore.instance.collection('timeline');
final messagesRef = Firestore.instance.collection('messages');
final storageRef = FirebaseStorage.instance.ref();
final timestamp = DateTime.now();
final User currentUser = User(
  id: '123',
  bio: 'I am demo',
  firstName: 'Akshat',
  lastName: 'Bhatia',
  email: 'akshatbhatia05@gmail.com',
  number: '393289374',
  photoUrl:
      'https://upload.wikimedia.org/wikipedia/commons/b/b3/Rowan_Atkinson_2011_2_cropped.jpg',
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChatApp();
  }
}
