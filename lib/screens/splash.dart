import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/screens/root_page.dart';

class Splash extends StatefulWidget {
  final BaseAuth auth;
  Splash({this.auth});
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String userId = "";
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() {
    Timer(
      Duration(milliseconds: 500),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => RootPage(
            auth: widget.auth,
            userId: userId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.red),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.add_circle_outline,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      "REACHOUT",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 13.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
