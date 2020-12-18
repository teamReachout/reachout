import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final BaseAuth auth = Auth();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white70,
      ),
    );
    return MaterialApp(
      title: 'Reachout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      // home: SafeArea(child: Home()),
      home: Splash(
        auth: widget.auth,
      ),
    );
  }
}
