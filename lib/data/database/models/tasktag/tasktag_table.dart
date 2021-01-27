import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('TaskTagData')
class TaskTagTable extends Table {
  TextColumn get taskId =>
      text().customConstraint('REFERENCES task_table(id)')();
  TextColumn get tagId => text().customConstraint('REFERENCES tag_table(id)')();

  @override
  String get tableName => 'tasktag_table';

  @override
  Set<Column> get primaryKey => {taskId, tagId};

  static TaskTagTableCompanion fromTaskResult(TaskResult task, String tagId) {
    return TaskTagTableCompanion(
      taskId: Value(task.taskId),
      tagId: Value(tagId),
    );
  }
}
