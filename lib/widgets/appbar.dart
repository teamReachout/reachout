import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/screens/chat_list.dart';
import 'package:reachout/widgets/search.dart';

class Appbar extends StatefulWidget {
  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  chatList() {
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
      toolbarOpacity: 1.0,
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
      title: Text('Reachout'.toUpperCase(),
          style: GoogleFonts.roboto(
            fontSize: 20,
              fontWeight: FontWeight.w300,
              color: const Color.fromRGBO(244, 248, 245, 1),
              letterSpacing: 1.2)),
    );
  }
}
