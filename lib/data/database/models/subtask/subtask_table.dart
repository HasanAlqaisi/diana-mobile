import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:moor/moor.dart';

@DataClassName('SubTaskData')
class SubTaskTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().customConstraint(
      'REFERENCES task_table(id) ON DELETE CASCADE ON UPDATE CASCADE')();
  TextColumn get name => text()();
  BoolColumn get done => boolean().withDefault(Constant(false))();

  @override
  String get tableName => 'subtask_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<SubTaskTableCompanion> fromSubTaskResponse(
      List<SubtaskResult> subtasks) {
    return subtasks
        .map((subtask) => SubTaskTableCompanion(
              id: Value(subtask.id),
              taskId: Value(subtask.taskId),
              name: Value(subtask.name),
              done: Value(subtask.done),
            ))
        .toList();
  }

  static SubTaskTableCompanion fromSubTaskResult(SubtaskResult subtask) {
    return SubTaskTableCompanion(
      id: Value(subtask.id),
      taskId: Value(subtask.taskId),
      name: Value(subtask.name),
      done: Value(subtask.done),
    );
  }
}
