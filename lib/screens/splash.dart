import 'dart:async';

import 'package:reachout/widgets/loading_indicator.dart';
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
      Duration(milliseconds: 1500),
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
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        child: Image.asset(
                          'images/reachout.png',
                          width: 100.0,
                          height: 100.0,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Text(
                      "REACHOUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        fontSize: 24
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: LoadingIndicator(
                  isWhite: true,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
