import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgressIndicator(
        strokeWidth: 10,
      ),
    );
  }
}