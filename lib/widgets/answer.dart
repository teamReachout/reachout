import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        ListTile(
          title: Text(userName),
          subtitle: Text(answer),
          trailing: Text(
            timeago.format(
              timestamp.toDate(),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
        ),
      ],
    );
  }
}
