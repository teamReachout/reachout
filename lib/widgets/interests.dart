import 'package:flutter/material.dart';

class Interests extends StatefulWidget {
  final String interest;

  const Interests({Key key, this.interest}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InterestsState();
  }
}

class InterestsState extends State<Interests> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        // right: 2.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Chip(
        label: Text(widget.interest),
      ),
    );
  }
}
