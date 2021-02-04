import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter/material.dart';

class QuickAddField extends StatelessWidget {
  const QuickAddField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextField(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey[300], width: 3),
          ),
          hintText: 'Quick task',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.add, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey[300], width: 3),
          ),
        ),
        onSubmitted: (taskName) {
          TaskController.to
              .addTask(taskName, null, null, [], null, null, 0, false);
        },
      ),
    );
  }
}
