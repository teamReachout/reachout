import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/screens/splash.dart';

Map<int, Color> color =
{
50:Color.fromRGBO(136,14,79, .1),
100:Color.fromRGBO(136,14,79, .2),
200:Color.fromRGBO(136,14,79, .3),
300:Color.fromRGBO(136,14,79, .4),
400:Color.fromRGBO(136,14,79, .5),
500:Color.fromRGBO(136,14,79, .6),
600:Color.fromRGBO(136,14,79, .7),
700:Color.fromRGBO(136,14,79, .8),
800:Color.fromRGBO(136,14,79, .9),
900:Color.fromRGBO(136,14,79, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF222831, color);

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
        statusBarColor: colorCustom
      ),
    );
    return MaterialApp(
      title: 'Reachout',
      theme: ThemeData(
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      // home: SafeArea(child: Home()),
      home: SafeArea(
              child: Splash(
          auth: widget.auth,
        ),
      ),
    );
  }
}
