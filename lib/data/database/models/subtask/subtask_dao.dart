import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/subtask/subtask_table.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:drift/drift.dart';

part 'subtask_dao.g.dart';

@DriftAccessor(tables: [SubTaskTable])
class SubTaskDao extends DatabaseAccessor<AppDatabase> with _$SubTaskDaoMixin {
  SubTaskDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertSubTasks(
    SubtaskResponse subtaskResponse,
  ) async {
    return transaction(() async {
      await delete(subTaskTable).go();
      await batch((batch) {
        batch.insertAll(subTaskTable,
            SubTaskTable.fromSubTaskResponse(subtaskResponse.results!),
            mode: InsertMode.replace);
      });
    });
  }

  Future<void> insertSubTasks(SubtaskResponse subtaskResponse) async {
    await batch((batch) {
      batch.insertAll(subTaskTable,
          SubTaskTable.fromSubTaskResponse(subtaskResponse.results!),
          mode: InsertMode.replace);
    });
  }

  Future<int> deleteSubTask(String subtaskId) {
    return (delete(subTaskTable)..where((tbl) => tbl.id.equals(subtaskId)))
        .go();
  }

  Future<int> insertSubTask(SubtaskResult subtaskResult) {
    return into(subTaskTable).insert(
        SubTaskTable.fromSubTaskResult(subtaskResult),
        mode: InsertMode.replace);
  }
}
