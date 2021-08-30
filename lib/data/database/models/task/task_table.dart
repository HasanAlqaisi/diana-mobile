import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:moor/moor.dart';

@DataClassName('TaskData')
class TaskTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().customConstraint(
      'REFERENCES user_table(id) ON DELETE CASCADE ON UPDATE CASCADE')();
  TextColumn get name => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  DateTimeColumn get reminder => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get priority => integer().nullable()();
  DateTimeColumn get doneAt => dateTime().nullable()();

  @override
  String get tableName => 'task_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<TaskTableCompanion> fromTaskResponse(List<TaskResult> tasks) {
    return tasks
        .map((task) => TaskTableCompanion(
              id: Value(task.taskId!),
              userId: Value(task.userId!),
              name: Value(task.name!),
              note: Value(task.note),
              date: Value(
                task.date != null
                    ? DateTime.tryParse(task.date! + ' 00:00:00.000Z')
                    : null,
              ),
              reminder: Value(task.reminder != null
                  ? DateTime.tryParse(task.reminder!)
                  : null),
              deadline: Value(task.deadline != null
                  ? DateTime.tryParse(task.deadline!)
                  : null),
              priority: Value(task.priority),
              doneAt: Value(
                  task.doneAt != null ? DateTime.tryParse(task.doneAt!) : null),
            ))
        .toList();
  }

  static TaskTableCompanion fromTaskResult(TaskResult task) {
    print('Task ${task.name} has a done date ${task.doneAt}');
    return TaskTableCompanion(
      id: Value(task.taskId!),
      userId: Value(task.userId!),
      name: Value(task.name!),
      note: Value(task.note),
      date: Value(
        task.date != null
            ? DateTime.tryParse(task.date!)?.add(Duration(hours: 12))
            : null,
      ),
      reminder: Value(
          task.reminder != null ? DateTime.tryParse(task.reminder!) : null),
      deadline: Value(
          task.deadline != null ? DateTime.tryParse(task.deadline!) : null),
      priority: Value(task.priority),
      doneAt:
          Value(task.doneAt != null ? DateTime.tryParse(task.doneAt!) : null),
    );
  }
}
