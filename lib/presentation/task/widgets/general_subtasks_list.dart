import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter/material.dart';

class GeneralSubtasksList extends StatelessWidget {
  const GeneralSubtasksList({
    Key key,
    @required this.taskWithSubtasks,
  }) : super(key: key);

  final TaskWithSubtasks taskWithSubtasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: taskWithSubtasks?.subtasks?.length ?? 0,
      itemBuilder: (context, index) {
        final subtask = taskWithSubtasks?.subtasks[index];
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subtask.name,
                  style: TextStyle(
                      decoration:
                          subtask.done ? TextDecoration.lineThrough : null,
                      color:
                          subtask.done ? Color(0xFF1ADACE) : Color(0xFF636363)),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    TaskController.to.changeSubtaskState(subtask);
                  },
                  child: Icon(
                    Icons.check,
                    color: subtask.done ? Color(0xFF1ADACE) : Color(0xFFB0B0B0),
                  )),
            ],
          ),
          subtitle: Divider(thickness: 0.5),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        );
      },
    );
  }
}
