import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/subtask/subtask_table.dart';
import 'package:diana/data/database/models/tag/tag_table.dart';
import 'package:diana/data/database/models/task/task_table.dart';
import 'package:diana/data/database/models/tasktag/tasktag_table.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'task_dao.g.dart';

@UseDao(tables: [TaskTable, SubTaskTable, TaskTagTable, TagTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertTasks(
    TaskResponse taskResponse,
    TagResponse tagResopnse,
    SubtaskResponse subtaskResponse,
  ) async {
    return transaction(() async {
      // Clear the tables associated with task
      await delete(taskTable).go();
      await delete(subTaskTable).go();
      await delete(taskTagTable).go();
      await delete(tagTable).go();
      // Insert data for task, tag, subtask, tasktag
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
            taskTable, TaskTable.fromTaskResponse(taskResponse.results));

        batch.insertAllOnConflictUpdate(subTaskTable,
            SubTaskTable.fromSubTaskResponse(subtaskResponse.results));

        batch.insertAllOnConflictUpdate(
            tagTable, TagTable.fromTagResponse(tagResopnse.results));

        taskResponse.results.forEach(
          (task) => task.tags.forEach(
            (tag) => batch.insert(
              taskTagTable,
              TaskTagTable.fromTaskResult(task, tag),
              mode: InsertMode.insertOrReplace,
            ),
          ),
        );
      });
    });
  }

  Future<void> insertTasks(
    TaskResponse taskResponse,
    TagResponse tagResponse,
    SubtaskResponse subtaskResponse,
  ) async {
    return transaction(() async {
      // Insert data for task, tag, subtask, tasktag
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
            taskTable, TaskTable.fromTaskResponse(taskResponse.results));

        batch.insertAllOnConflictUpdate(subTaskTable,
            SubTaskTable.fromSubTaskResponse(subtaskResponse.results));

        batch.insertAllOnConflictUpdate(
            tagTable, TagTable.fromTagResponse(tagResponse.results));

        taskResponse.results.forEach(
          (task) => task.tags.forEach(
            (tag) => batch.insert(
              taskTagTable,
              TaskTagTable.fromTaskResult(task, tag),
              mode: InsertMode.insertOrReplace,
            ),
          ),
        );
      });
    });
  }

  /// Return today incompleted tasks with its subtasks, for specific user
  /// How do we know it's for today? compare time with deadline
  Future<Stream<List<TaskWithSubtasks>>> watchTodayTasks(String userId) async {
    return (((select(taskTable)..where((tbl) => tbl.userId.equals(userId)))..where((tbl) => tbl.doneAt.equals(null)))
          ..where((tbl) =>
              tbl.deadline.day.equals(DateTime.now().day) &
              tbl.deadline.isBiggerThanValue(DateTime.now())))
        .join([
          leftOuterJoin(
              subTaskTable, subTaskTable.taskId.equalsExp(taskTable.id))
        ])
        .watch()
        .map((rows) {
          final result = <TaskData, List<SubTaskData>>{};
          for (final row in rows) {
            final task = row.readTable(taskTable);
            final subtask = row.readTable(subTaskTable);

            final list = result.putIfAbsent(task, () => []);
            if (subtask != null) list.add(subtask);
          }
          return [
            for (final entry in result.entries)
              TaskWithSubtasks(task: entry.key, subtasks: entry.value)
          ];
        });
  }

  /// Return all incompleted tasks with its subtasks
  Future<Stream<List<TaskWithSubtasks>>> watchAllTasks(String userId) async {
    return ((select(taskTable)..where((tbl) => tbl.userId.equals(userId)))
          ..where((tbl) => tbl.doneAt.equals(null)))
        .join([
          leftOuterJoin(
              subTaskTable, subTaskTable.taskId.equalsExp(taskTable.id))
        ])
        .watch()
        .map((rows) {
          final result = <TaskData, List<SubTaskData>>{};
          for (final row in rows) {
            final task = row.readTable(taskTable);
            final subtask = row.readTable(subTaskTable);

            final list = result.putIfAbsent(task, () => []);
            if (subtask != null) list.add(subtask);
          }
          return [
            for (final entry in result.entries)
              TaskWithSubtasks(task: entry.key, subtasks: entry.value)
          ];
        });
  }

  Future<Stream<List<TaskWithSubtasks>>> watchCompletedTasks(
      String userId) async {
    return ((select(taskTable)..where((tbl) => tbl.userId.equals(userId)))
          ..where((tbl) => tbl.doneAt.isNotIn(null)))
        .join([
          leftOuterJoin(
              subTaskTable, subTaskTable.taskId.equalsExp(taskTable.id))
        ])
        .watch()
        .map((rows) {
          final result = <TaskData, List<SubTaskData>>{};
          for (final row in rows) {
            final task = row.readTable(taskTable);
            final subtask = row.readTable(subTaskTable);

            final list = result.putIfAbsent(task, () => []);
            if (subtask != null) list.add(subtask);
          }
          return [
            for (final entry in result.entries)
              TaskWithSubtasks(task: entry.key, subtasks: entry.value)
          ];
        });
  }

  Future<Stream<List<TaskWithSubtasks>>> watchMissedTasks(String userId) async {
    return ((select(taskTable)..where((tbl) => tbl.userId.equals(userId)))
          ..where((tbl) => tbl.deadline.isSmallerThanValue(DateTime.now())))
        .join([
          leftOuterJoin(
              subTaskTable, subTaskTable.taskId.equalsExp(taskTable.id))
        ])
        .watch()
        .map((rows) {
          final result = <TaskData, List<SubTaskData>>{};
          for (final row in rows) {
            final task = row.readTable(taskTable);
            final subtask = row.readTable(subTaskTable);

            final list = result.putIfAbsent(task, () => []);
            if (subtask != null) list.add(subtask);
          }
          return [
            for (final entry in result.entries)
              TaskWithSubtasks(task: entry.key, subtasks: entry.value)
          ];
        });
  }
}
