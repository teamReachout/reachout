import 'package:flutter/material.dart';
import 'package:reachout/screens/chat_list.dart';
import 'package:reachout/widgets/search.dart';

class Appbar extends StatefulWidget {
  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  chatList() {
    print('cvlkjhjkjhjk');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ChatList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: const Radius.circular(7),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.send,
            color: const Color.fromRGBO(244, 248, 245, 1),
          ),
          onPressed: chatList,
        ),
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
      title: Text(
        'ReachOut',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color.fromRGBO(244, 248, 245, 1),
        ),
      ),
    );
  }
}
