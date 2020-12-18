import 'package:flutter/material.dart';
import 'package:reachout/widgets/appbar.dart';

class Opportunities extends StatefulWidget {
  @override
  _OpportunitiesState createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<Opportunities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Appbar(),
        preferredSize: const Size.fromHeight(44),
      ),
    );
  }
}
