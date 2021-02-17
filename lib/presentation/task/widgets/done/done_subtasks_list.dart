import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:flutter/material.dart';

class DoneSubtasksList extends StatelessWidget {
  const DoneSubtasksList({
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
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subtask.name,
                    style: TextStyle(
                        color: Color(0xFFA8FFF9),
                        decoration: TextDecoration.lineThrough)),
                // Icon(Icons.check, color: Color(0xFFB0B0B0)),
              ],
            ),
          ),
          subtitle: Divider(thickness: 0.5),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        );
      },
    );
  }
}
