import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  const RoundedButton({this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
      onPressed: () {
        onPressed?.call();
      },
      child: child,
      color: Color(0xFF612EF3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
