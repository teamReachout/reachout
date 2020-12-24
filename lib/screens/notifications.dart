import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/home.dart';
import 'package:reachout/screens/requests_page.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:reachout/widgets/notification_item.dart';
import 'package:reachout/widgets/search.dart';



class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future getNotifications;
  int numberRequests;
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

  goToRequests() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => RequestsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          centerTitle: true,
          toolbarOpacity: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: const Radius.circular(7),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: goToRequests,
                child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(
                              CupertinoIcons.person,
                              color: const Color.fromRGBO(244, 248, 245, 1),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(0),
                            child: StreamBuilder<QuerySnapshot>(

                                stream: requestsRef
                                    .document(currentUser.id)
                                    .collection('userRequests').
                                    snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData)
                                  {
                                    return LoadingIndicator();
                                  }
                                 numberRequests = snapshot.data.documents.length;
                                 return Text(
                                '(${numberRequests.toString()})',
                                style: TextStyle(color: Colors.white),
                              );

                                })


                            )
                      ],
                    ))),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.search,
              color: const Color.fromRGBO(244, 248, 245, 1),
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: Search(),
            ),
          ),
          primary: true,
          title: Text('Reachout'.toUpperCase(),
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(244, 248, 245, 1),
                  letterSpacing: 1.2)),
        ),
        preferredSize: const Size.fromHeight(55),
      ),
      body: Column(
        children: <Widget>[
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
