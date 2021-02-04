import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:flutter/material.dart';

class SubtasksList extends StatelessWidget {
  const SubtasksList({
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
          title: Text(subtask.name, style: TextStyle(color: Color(0xFF636363))),
          trailing: Icon(Icons.check),
          subtitle: Divider(thickness: 0.5),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        );
      },
    );
  }
}
