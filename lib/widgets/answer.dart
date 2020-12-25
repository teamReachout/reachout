import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

class Answer extends StatelessWidget {
  final String userName;
  final String userId;
  final String answer;
  final Timestamp timestamp;

  Answer({
    this.answer,
    this.timestamp,
    this.userId,
    this.userName,
  });

  factory Answer.fromDocument(DocumentSnapshot doc) {
    return Answer(
      userName: doc['firstName'],
      userId: doc['userId'],
      answer: doc['answer'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2, color: Colors.black26) )
          ),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(userName,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w700)),
            ),
            subtitle: Text(answer,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                )),
            trailing: Text(
              timeago.format(
                timestamp.toDate(),
              ),
            ),
          ),
        ),
        // Divider(
        //   endIndent: 0,
        //   indent: 0,
        //   color: Colors.black12,
        // )
      ],
    );
  }
}
