import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/utils/progress_loader.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter/material.dart';

class SubtasksList extends StatelessWidget {
  final TaskType type;
  SubtasksList({
    Key key,
    @required this.taskWithSubtasks,
    @required this.type,
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
                    decoration: subtask.done || type == TaskType.done
                        ? TextDecoration.lineThrough
                        : null,
                    color: _colorSubtaskName(
                        taskType: type, isSubtaskDone: subtask.done),
                  ),
                ),
              ),
              if (type != TaskType.done)
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: subtask.done ? Color(0xFF1ADACE) : Color(0xFFB0B0B0),
                  ),
                  onPressed: () async {
                    showLoaderDialog();
                    await TaskController.to.changeSubtaskState(subtask);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          subtitle: Divider(thickness: 0.5),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        );
      },
    );
  }

  Color _colorSubtaskName({TaskType taskType, bool isSubtaskDone}) {
    if (taskType == TaskType.done) {
      return Color(0xFFA8FFF9);
    } else {
      if (isSubtaskDone) {
        return Color(0xFF1ADACE);
      } else {
        return Color(0xFF636363);
      }
    }
  }
}
