import 'package:diana/core/constants/constants.dart';
import 'package:diana/presentation/task/controller/add_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubtaskField extends StatelessWidget {
  final int index;
  final Function(SubtaskField) removeField;

  SubtaskField({
    Key key,
    @required this.index,
    @required this.removeField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddTaskController.to;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            style: TextStyle(color: Color(0xFFA687FF)),
            decoration: InputDecoration(
              hintText: 'New sub task',
              hintStyle: TextStyle(color: Color(0xFFA687FF)),
              prefixIcon: GestureDetector(
                onTap: () {
                  removeField(this);
                  controller.subtasksNames.remove(index);
                },
                child: Icon(FontAwesomeIcons.minus, color: Colors.white),
              ),
            ),
            validator: (subtaskName) {
              if (subtaskName.trim().isEmpty) return requireFieldMessage;
              controller.subtasksNames.add(subtaskName);
              return null;
            },
          ),
        ),
      ],
    );
  }
}
