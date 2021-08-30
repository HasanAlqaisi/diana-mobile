import 'package:diana/data/database/app_database/app_database.dart';

/// many-to-many relationship - Wrapper class
class TagWithTasks {
  final TagData? tag;
  final List<TaskData?>? tasks;

  TagWithTasks({this.tag, this.tasks});

  @override
  String toString() {
    return 'classInfo - name: ${tag!.name}, id: ${tag!.id}\n studentsInfo: $tasks';
  }
}
