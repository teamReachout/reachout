import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/screens/notifications.dart';
import 'package:reachout/screens/opportunities.dart';
import 'package:reachout/screens/upload.dart';
import 'package:reachout/screens/user_feed.dart';
import 'screens/profile_page.dart';
import 'models/users.dart';

final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final projectPostsRef = Firestore.instance.collection('projectPosts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final tagsRef = Firestore.instance.collection('tags');
final timelineRef = Firestore.instance.collection('timeline');
final projectRef = Firestore.instance.collection('projects');
final messagesRef = Firestore.instance.collection('messages');
final requestsRef = Firestore.instance.collection('requests');
final storageRef = FirebaseStorage.instance.ref();
final timestamp = DateTime.now();

User currentUser;

class Home extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  String userId;
  Home({this.auth, this.onSignedOut, this.userId});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget getPage(int index) {
    if (index == 0 && currentUser != null) {
      return UserFeed(
        currentUser: currentUser,
      );
    }
    if (index == 1) {
      return Opportunities();
    }
    if (index == 2) {
      return Upload();
    }
    if (index == 3) {
      return Notifications();
    }
    if (index == 4) {
      return ProfilePage(
        profileId: currentUser.id,
        onSignedOut: widget.onSignedOut,
      );
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 44,
        child: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(244, 248, 245, 1),
          elevation: 4,
          selectedItemColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Color.fromRGBO(89, 89, 89, 1),
          currentIndex: _selectedPageIndex,
          showSelectedLabels: false,
          selectedIconTheme: IconThemeData(size: 30),
          iconSize: 24,
          items: [
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.homeCircleOutline),
              activeIcon: Icon(MdiIcons.homeCircle),
              title: Container(
                height: 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.helpCircleOutline),
              activeIcon: Icon(MdiIcons.helpCircle),
              title: Container(
                height: 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              title: Container(
                height: 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.viewCarouselOutline),
              activeIcon: Icon(MdiIcons.viewCarousel),
              title: Container(
                height: 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              title: Container(
                height: 0,
              ),
            ),
          ],
          onTap: _selectPage,
        ),
      ),
      body: getPage(_selectedPageIndex),
    );
  }
}
