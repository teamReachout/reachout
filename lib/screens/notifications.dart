import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/constants.dart';
import 'package:reachout/screens/requests_page.dart';
import 'package:reachout/widgets/appbar.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:reachout/widgets/notification_item.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:reachout/screens/requests_page.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future getNotifications;
  @override
  void initState() {
    super.initState();
    getNotifications = getActivityFeed();
  }

  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<NotificationItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(NotificationItem.fromDocument(doc));
    });
    return feedItems;
  }

  buildNotifications(data) {
    return Column(
      children: <Widget>[
        ...data.toList(),
      ],
    );
  }

  goToRequests() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => RequestsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Appbar(),
        preferredSize: const Size.fromHeight(44),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 5.0, 6.0, 6.0),
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              // onPressed: 
              onPressed:  goToRequests,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                // elevation: MaterialStateProperty.all(2.0),
                padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                shape: MaterialStateProperty.all(ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(2))),
              ),
              child: Text(
                'YOUR REQUESTS',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: FutureBuilder(
                future: getNotifications,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingIndicator();
                  } else {
                    return ListView(
                      children: [
                        buildNotifications(snapshot.data),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
