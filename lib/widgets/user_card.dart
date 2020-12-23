import 'package:flutter/material.dart';
import 'package:reachout/models/users.dart';

class UserCard extends StatefulWidget {
  final User user;

  UserCard({this.user});
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.black12),
          borderRadius: BorderRadius.circular(10.0),
          ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.user.photoUrl),
          ),
          title: Text(widget.user.firstName),
          onTap: null,
        ),
      ),
    );
  }
}
