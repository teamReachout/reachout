import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/home.dart';

class OnBoardingPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  String userId;
  OnBoardingPage({
    this.auth,
    this.onSignedOut,
    this.userId,
  });
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => Home(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
            userId: widget.userId,
          ),
        ),
        (Route<dynamic> route) => false);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "YOUR PLACE TO LEARN",
          body: "Learn from the other entrepreneurs' skills and experiences",
          image: _buildImage('community'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "SHOW YOUR WORK",
          body: "Share your experiences and business with others",
          image: _buildImage('showYourWork'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "REACHOUT",
          body:
              "Reachout to other entrepreneurs, freelancers and investors to collaborate and grow",
          image: _buildImage('collaborations'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "DOUBTS AND RESOURCES",
          body:
              "Clear doubts and find resources in our doubt forum",
          image: _buildImage('doubt'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "EXPLORE",
          body:
              "Explore opportunities like competitions, business conclaves and trade shows",
          image: _buildImage('opportunities'),
          footer: RaisedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'Go Back',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: Color(0xFF880E4F),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
