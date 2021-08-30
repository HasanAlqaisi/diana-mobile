import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/presentation/task/controller/add_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubtaskField extends StatelessWidget {
  final int index;
  final Function(SubtaskField) removeField;
  final String? text;

  SubtaskField({
    Key? key,
    this.text,
    required this.index,
    required this.removeField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddTaskController.to;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: TextFormField(
            controller: TextEditingController(text: text),
            style: TextStyle(color: Color(0xFFA687FF)),
            decoration: InputDecoration(
              hintText: 'New sub task',
              hintStyle: TextStyle(color: Color(0xFFA687FF)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA687FF), width: 0.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA687FF), width: 0.5),
              ),
              errorText: controller.failure is SubtaskFieldsFailure
                  ? (controller.failure as SubtaskFieldsFailure?)?.name?.first
                  : null,
              prefixIcon: GestureDetector(
                onTap: () {
                  removeField(this);
                  controller.subtasksNames.remove(index);
                },
                child:
                    Icon(FontAwesomeIcons.minus, color: Colors.white, size: 18),
              ),
            ),
            validator: (subtaskName) {
              if (subtaskName!.trim().isEmpty) return requireFieldMessage;
              if (!controller.subtasksNames.contains(subtaskName))
                controller.subtasksNames.add(subtaskName);
              return null;
            },
          ),
        ),
      ],
    );
  }
}
