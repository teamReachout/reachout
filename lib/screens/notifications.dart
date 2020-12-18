import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/widgets/appbar.dart';
import 'package:reachout/widgets/loading_indicator.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    snapshot.documents.forEach((doc) {
      print(doc.data);
    });
    return snapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Appbar(),
        preferredSize: const Size.fromHeight(44),
      ),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              return Text('data');
            }
          },
        ),
      ),
    );
  }
}
