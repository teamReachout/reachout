import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/widgets/user_chat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int followingCount = 0;
  List<User> chats = [];
  @override
  void initState() {
    super.initState();
    getFollowing();
  }

  getFollowing() async {
    QuerySnapshot doc = await followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCount = doc.documents.length;
    });
    // print(followingCount);
    doc.documents.forEach((e) async {
      DocumentSnapshot document = await usersRef.document(e.documentID).get();
      User user = User.fromDocument(document);
      setState(() {
        chats.add(user);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Container(
                color: Color(0xFF393e46),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 14
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'CHATS',
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.8),
                      ),
                      Icon(
                        Icons.add_sharp,
                        size: 34,
                        color: Colors.white,
                        // color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: TextField(
                  decoration: InputDecoration(
                      focusColor: Colors.red,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))))),
            ),
            ListView.builder(
              itemCount: chats.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return UserChat(
                  sender: currentUser,
                  reciever: chats[i],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
