import 'package:diana/data/database/app_database/app_database.dart';

///one-to-many relationship
class TaskWithSubtasks {
  final TaskData? task;
  final List<SubTaskData>? subtasks;

  TaskWithSubtasks({this.task, this.subtasks});

  @override
  String toString() {
    return '''   task info: ${task!.name}
    subtask info: $subtasks
    ''';
  }
}
