import 'package:flutter/material.dart';

class DayText extends StatelessWidget {
  final String text;
  final Color color;
  final bool hasBorder;

  const DayText({
    Key? key,
    required this.text,
    required this.color,
    required this.hasBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: hasBorder ? EdgeInsets.symmetric(vertical: 4.0) : null,
        padding: hasBorder ? EdgeInsets.all(4.0) : null,
        decoration: BoxDecoration(
          border: hasBorder ? Border.all(color: Colors.blueAccent) : null,
        ),
        child: Text(text, style: TextStyle(color: color)));
  }
}
