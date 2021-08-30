import 'package:flutter/material.dart';

class PriorityWidget extends StatelessWidget {
  final int? priority;
  final Color color;

  const PriorityWidget({
    Key? key,
    required this.priority,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
      priority!,
      (index) => Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          index + 1 != priority
              ? SizedBox(
                  width: 10,
                  child: Divider(
                    color: color,
                    thickness: 1,
                  ))
              : Container(),
        ],
      ),
    ));
  }
}
