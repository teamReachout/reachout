import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/screens/requests_page.dart';
import 'package:reachout/widgets/appbar.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:reachout/widgets/notification_item.dart';
import 'package:timeago/timeago.dart' as timeago;

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
          Flexible(
            child: GestureDetector(
              onTap: goToRequests,
              child: ListTile(
                title: Text('YOUR REQUESTS'),
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
