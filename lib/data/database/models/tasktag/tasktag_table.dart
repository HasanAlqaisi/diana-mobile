import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('TaskTagData')
class TaskTagTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().customConstraint('REFERENCES task_table(id)')();
  TextColumn get tagId => text().customConstraint('REFERENCES tag_table(id)')();

  @override
  String get tableName => 'tasktag_table';

  @override
  Set<Column> get primaryKey => {id};

  static TaskTagTableCompanion fromTaskTagResposne(TaskTagResponse tasktag) {
    return TaskTagTableCompanion(
      id: Value(tasktag.id),
      taskId: Value(tasktag.taskId),
      tagId: Value(tasktag.tagId),
    );
  }
}
