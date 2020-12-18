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
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(widget.user.photoUrl),
        ),
        title: Text(widget.user.firstName),
        onTap: null,
      ),
    );
  }
}
