import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  List<User> requests = [];
  int numberOfRequests;

  @override
  void initState() {
    super.initState();
    getUserRequests();
  }

  getUserRequests() async {
    QuerySnapshot doc = await requestsRef
        .document(currentUser.id)
        .collection('userRequests')
        .getDocuments();
         int number = doc.documents.length;
         print(number);
    doc.documents.forEach((doc) async {
      DocumentSnapshot documentSnapshot =
          await usersRef.document(doc.documentID).get();
      setState(() {
        requests.add(
          User.fromDocument(documentSnapshot),
        );
      });
    });
  }

  int requestNumber() {
    numberOfRequests = requests.length;
    return numberOfRequests;
  }

  deleteRequest(String reqId) {
    print('object');
    requestsRef
        .document(currentUser.id)
        .collection('userRequests')
        .document(reqId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
      getUserRequests();
    });
  }

  acceptRequest(String reqId) {
    print('Accepted');
    followersRef
        .document(currentUser.id)
        .collection('userFollowers')
        .document(reqId)
        .setData({});
    followingRef
        .document(reqId)
        .collection('userFollowing')
        .document(currentUser.id)
        .setData({});
    activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .document(reqId)
        .setData({
      'type': 'follow',
      'ownerId': currentUser.id,
      'userId': reqId,
      'username': currentUser.firstName,
      'userProfileImg': currentUser.photoUrl,
      'timestamp': timestamp,
    });
    deleteRequest(reqId);
  }

  buildItems(User req) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              req.firstName + ' ' + req.lastName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            trailing: Container(
              height: 10,
              width: 100,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: GestureDetector(
                      onTap: () => acceptRequest(req.id),
                      child: Icon(Icons.done),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: GestureDetector(
                      onTap: () => deleteRequest(req.id),
                      child: Icon(Icons.block),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromRGBO(244, 248, 245, 1),
          ),
          onPressed: () {
            Navigator.pop(context, requestNumber());
          }
          ),
        primary: true,
        title: Text('FOLLOW REQUESTS'.toUpperCase(),
            style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: const Color.fromRGBO(244, 248, 245, 1),
                letterSpacing: 1.2)),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (ctx, i) {
            return buildItems(requests[i]);
          },
        ),
      ),
    );
  }
}
