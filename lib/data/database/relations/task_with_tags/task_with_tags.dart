import 'package:diana/data/database/app_database/app_database.dart';

/// many-to-many relationship - Wrapper class
class TaskWithTags {
  final TaskData? task;
  final List<TagData?>? tags;

  TaskWithTags({this.task, this.tags});

  @override
  String toString() {
    return 'classInfo - name: ${task!.name}, id: ${task!.id}\n studentsInfo: $tags';
  }
}
