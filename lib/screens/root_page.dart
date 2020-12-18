import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/screens/login_page.dart';
import 'package:reachout/screens/on_boarding_page.dart';
import 'package:reachout/widgets/loading_indicator.dart';

enum AuthStatus {
  //NotDetermined,
  SignedIn,
  NotSignedIn
}
AuthStatus authStatus = AuthStatus.NotSignedIn;

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  String userId;
  RootPage({this.auth, this.userId});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool isLoading = false;
  bool newLogin = false;
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        if (user != null) {
          widget.userId = user?.uid;
          getCurrentUser();
        }
        authStatus =
            user?.uid == null ? AuthStatus.NotSignedIn : AuthStatus.SignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      newLogin = true;
      authStatus = AuthStatus.SignedIn;
      widget.auth.currentUser().then((user) {
        widget.userId = user.uid.toString();
      });
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.NotSignedIn;
      widget.userId = "";
    });
  }

  getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.userId).get();
    currentUser = User.fromDocument(doc);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NotSignedIn:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.SignedIn:
        return isLoading
            ? LoadingIndicator()
            : newLogin
                ? OnBoardingPage(
                    auth: widget.auth,
                    onSignedOut: _signedOut,
                    userId: widget.userId,
                  )
                : Home(
                    auth: widget.auth,
                    onSignedOut: _signedOut,
                    userId: widget.userId,
                  );
        break;
    }
  }
}
