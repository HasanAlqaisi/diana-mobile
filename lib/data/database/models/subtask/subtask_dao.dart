import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/subtask/subtask_table.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'subtask_dao.g.dart';

@UseDao(tables: [SubTaskTable])
class SubTaskDao extends DatabaseAccessor<AppDatabase> with _$SubTaskDaoMixin {
  SubTaskDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertSubTasks(
    SubtaskResponse subtaskResponse,
  ) async {
    return transaction(() async {
      await delete(subTaskTable).go();
      await batch((batch) {
        batch.insertAllOnConflictUpdate(subTaskTable,
            SubTaskTable.fromSubTaskResponse(subtaskResponse.results));
      });
    });
  }

  Future<void> insertSubTasks(SubtaskResponse subtaskResponse) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(subTaskTable,
          SubTaskTable.fromSubTaskResponse(subtaskResponse.results));
    });
  }

  Future<int> deleteSubTask(String subtaskId) {
    return (delete(subTaskTable)..where((tbl) => tbl.id.equals(subtaskId)))
        .go();
  }

  Future<int> insertSubTask(SubtaskResult subtaskResult) {
    return into(subTaskTable)
        .insertOnConflictUpdate(SubTaskTable.fromSubTaskResult(subtaskResult));
  }
}
