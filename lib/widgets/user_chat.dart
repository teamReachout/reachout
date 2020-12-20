import 'package:flutter/material.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/screens/chat_app.dart';

class UserChat extends StatefulWidget {
  User sender;
  User reciever;

  UserChat({
    this.sender,
    this.reciever,
  });

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  chatApp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatApp(
          sender: widget.sender,
          receiver: widget.reciever,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(widget.reciever.photoUrl),
      ),
      title: Text(widget.reciever.firstName),
      subtitle: Text('widget.text'),
      trailing: Text('widget.time'),
      onTap: chatApp,
    );
  }
}
