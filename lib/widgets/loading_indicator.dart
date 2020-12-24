import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  bool isWhite = false;
  LoadingIndicator({this.isWhite = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: isWhite ? Colors.white : Colors.black,
        size: 30,
      ),
    );
  }
}
