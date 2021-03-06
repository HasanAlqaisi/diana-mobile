import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/subtask/subtask_table.dart';
import 'package:diana/data/database/models/tag/tag_table.dart';
import 'package:diana/data/database/models/task/task_table.dart';
import 'package:diana/data/database/models/tasktag/tasktag_table.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';

part 'task_dao.g.dart';

@UseDao(tables: [TaskTable, SubTaskTable, TaskTagTable, TagTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertTasks(
    TaskResponse taskResponse,
  ) async {
    return transaction(() async {
      // Clear the tables associated with task
      await delete(taskTable).go();
      await delete(subTaskTable).go();
      await delete(taskTagTable).go();
      // Insert data for task, tasktag
      await batch((batch) {
        batch.insertAll(
            taskTable, TaskTable.fromTaskResponse(taskResponse.results),
            mode: InsertMode.replace);

        taskResponse.results.forEach((task) {
          batch.insertAll(
              subTaskTable, SubTaskTable.fromSubTaskResponse(task.checkList),
              mode: InsertMode.replace);
        });

        taskResponse.results.forEach(
          (task) => task.tags.forEach(
            (tag) => batch.insert(
              taskTagTable,
              TaskTagTable.fromTaskResult(task, tag.id),
              mode: InsertMode.insertOrReplace,
            ),
          ),
        );
      });
    });
  }

  Future<void> insertTasks(TaskResponse taskResponse) async {
    return transaction(() async {
      // Insert data for task, tasktag
      await batch((batch) {
        batch.insertAll(
            taskTable, TaskTable.fromTaskResponse(taskResponse.results),
            mode: InsertMode.replace);

        taskResponse.results.forEach((task) {
          batch.insertAll(
              subTaskTable, SubTaskTable.fromSubTaskResponse(task.checkList),
              mode: InsertMode.replace);
        });

        taskResponse.results.forEach(
          (task) => task.tags.forEach(
            (tag) => batch.insert(
              taskTagTable,
              TaskTagTable.fromTaskResult(task, tag.id),
              mode: InsertMode.insertOrReplace,
            ),
          ),
        );
      });
    });
  }

  /// Return today incompleted tasks with its subtasks, for specific user
  /// How do we know it's for today? compare time with date field
  Stream<List<TaskWithSubtasks>> watchTodayTasks(
      String userId, List<String> tags) {
    return (((select(taskTable)
          ..where((tbl) {
            return tbl.userId.equals(userId) &
                isNull(tbl.doneAt) &
                tbl.date.day.equalsExp(currentDate.day) &
                (tbl.deadline.isBiggerThan(currentDateAndTime) |
                    isNull(tbl.deadline));
          })
          ..orderBy([
            (u) =>
                OrderingTerm(expression: u.priority, mode: OrderingMode.desc),
          ]))
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
        })));
  }

  /// Return all incompleted tasks with its subtasks
  Stream<List<TaskWithSubtasks>> watchAllTasks(
      String userId, List<String> tags) {
    return ((select(taskTable)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              isNull(tbl.doneAt) &
              (tbl.deadline.isBiggerThan(currentDateAndTime) |
                  isNull(tbl.deadline)))
          ..orderBy([
            (u) =>
                OrderingTerm(expression: u.priority, mode: OrderingMode.desc),
          ]))
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
        }));
  }

  Stream<List<TaskWithSubtasks>> watchCompletedTasks(
      String userId, List<String> tags) {
    return ((select(taskTable)..where((tbl) => tbl.userId.equals(userId)))
          ..where((tbl) => isNotNull(tbl.doneAt)))
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

  Stream<List<TaskWithSubtasks>> watchMissedTasks(
      String userId, List<String> tags) {
    return ((select(taskTable)..where((tbl) => tbl.userId.equals(userId)))
          ..where(
            (tbl) =>
                tbl.deadline.isSmallerThan(currentDateAndTime) &
                isNull(tbl.doneAt),
          ))
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

  Future<int> deleteTask(String taskId) {
    return (delete(taskTable)..where((tbl) => tbl.id.equals(taskId))).go();
  }

  Future<void> insertTask(TaskResult taskResult) {
    return transaction(() async {
      // Insert data for task, tasktag
      await batch((batch) {
        batch.insert(taskTable, TaskTable.fromTaskResult(taskResult),
            mode: InsertMode.replace);

        batch.insertAll(subTaskTable,
            SubTaskTable.fromSubTaskResponse(taskResult.checkList),
            mode: InsertMode.replace);

        taskResult.tags.forEach(
          (tag) => batch.insert(
            taskTagTable,
            TaskTagTable.fromTaskResult(taskResult, tag.id),
            mode: InsertMode.insertOrReplace,
          ),
        );
      });
    });
  }

  Stream<List<TagData>> watchAllTags(String userId) {
    return ((select(tagTable)..where((tbl) => tbl.userId.equals(userId)))
        .watch());
  }

  Stream<TaskWithTags> watchTagsForClass(String userId, String taskId) {
    final taskQuery = select(taskTable)
      ..where((task) => task.userId.equals(userId) & task.id.equals(taskId));
    final contentQuery = select(taskTagTable).join([
      innerJoin(tagTable, tagTable.id.equalsExp(taskTagTable.tagId)),
    ])
      ..where(taskTagTable.taskId.equals(taskId));

    final taskStream = taskQuery.watchSingle();
    final contentStream = contentQuery.watch().map((rows) {
      return rows.map((row) => row.readTable(tagTable)).toList();
    });

    return Rx.combineLatest2(
        taskStream,
        contentStream,
        (TaskData task, List<TagData> tags) =>
            TaskWithTags(task: task, tags: tags));
  }
}
