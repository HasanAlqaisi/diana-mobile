import 'package:flutter/material.dart';

class QuickAddField extends StatelessWidget {
  final String hint;
  final Function(String value) onSubmitted;
  final TextEditingController textController;

  const QuickAddField({
    @required this.hint,
    @required this.onSubmitted,
    @required this.textController,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey[300], width: 3),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
          prefixIcon: Icon(Icons.add, color: Colors.grey.withOpacity(0.7)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey[200], width: 3),
          ),
        ),
        onSubmitted: (taskName) {
          onSubmitted?.call(taskName);
        },
      ),
    );
  }
}
