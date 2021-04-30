import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/tag/tag_table.dart';
import 'package:diana/data/database/models/task/task_table.dart';
import 'package:diana/data/database/models/tasktag/tasktag_table.dart';
import 'package:diana/data/database/relations/tag_with_tasks/tag_with_tasks.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';

part 'tasktag_dao.g.dart';

@UseDao(tables: [TaskTable, TagTable, TaskTagTable])
class TaskTagDao extends DatabaseAccessor<AppDatabase> with _$TaskTagDaoMixin {
  TaskTagDao(AppDatabase db) : super(db);

  Future<void> insertTaskTag(TaskTagData taskTag) async {
    into(taskTagTable).insert(taskTag, mode: InsertMode.replace);
  }

  Stream<TagWithTasks> watchTodayTasksForTag(String id) {
    final tagQuery = select(tagTable)..where((tag) => tag.id.equals(id));
    final contentQuery = select(taskTagTable).join([
      innerJoin(taskTable, taskTable.id.equalsExp(taskTagTable.taskId)),
    ])
      ..where(taskTagTable.tagId.equals(id));

    final tagStream = tagQuery.watchSingle();
    final contentStream = (contentQuery
          ..where(taskTable.deadline.day.equals(DateTime.now().day) &
              taskTable.deadline.isBiggerThanValue(DateTime.now())))
        .watch()
        .map((rows) {
      return rows.map((row) => row.readTableOrNull(taskTable)).toList();
    });

    return Rx.combineLatest2(
        tagStream,
        contentStream,
        (TagData tag, List<TaskData> tasks) =>
            TagWithTasks(tag: tag, tasks: tasks));
  }

  Stream<TagWithTasks> watchAllTaskForTag(String id) {
    final tagQuery = select(tagTable)..where((tag) => tag.id.equals(id));
    final contentQuery = select(taskTagTable).join([
      innerJoin(taskTable, taskTable.id.equalsExp(taskTagTable.taskId)),
    ])
      ..where(taskTagTable.tagId.equals(id));

    final tagStream = tagQuery.watchSingle();
    final contentStream = contentQuery.watch().map((rows) {
      return rows.map((row) => row.readTableOrNull(taskTable)).toList();
    });

    return Rx.combineLatest2(
        tagStream,
        contentStream,
        (TagData tag, List<TaskData> tasks) =>
            TagWithTasks(tag: tag, tasks: tasks));
  }

  Stream<TagWithTasks> watchCompletedTasksForTag(String id) {
    final tagQuery = select(tagTable)..where((tag) => tag.id.equals(id));
    final contentQuery = select(taskTagTable).join([
      innerJoin(taskTable, taskTable.id.equalsExp(taskTagTable.taskId)),
    ])
      ..where(taskTagTable.tagId.equals(id));

    final tagStream = tagQuery.watchSingle();
    final contentStream = (contentQuery..where(taskTable.doneAt.isNotIn(null)))
        .watch()
        .map((rows) {
      return rows.map((row) => row.readTableOrNull(taskTable)).toList();
    });

    return Rx.combineLatest2(
        tagStream,
        contentStream,
        (TagData tag, List<TaskData> tasks) =>
            TagWithTasks(tag: tag, tasks: tasks));
  }

  Stream<TagWithTasks> watchMissedTasksForTag(String id) {
    final tagQuery = select(tagTable)..where((tag) => tag.id.equals(id));
    final contentQuery = select(taskTagTable).join([
      innerJoin(taskTable, taskTable.id.equalsExp(taskTagTable.taskId)),
    ])
      ..where(taskTagTable.tagId.equals(id));

    final tagStream = tagQuery.watchSingle();
    final contentStream = (contentQuery
          ..where(taskTable.deadline.isSmallerThanValue(DateTime.now())))
        .watch()
        .map((rows) {
      return rows.map((row) => row.readTableOrNull(taskTable)).toList();
    });

    return Rx.combineLatest2(
        tagStream,
        contentStream,
        (TagData tag, List<TaskData> tasks) =>
            TagWithTasks(tag: tag, tasks: tasks));
  }

  Future<int> deleteTaskTag(String taskId, tagId) {
    return (delete(taskTagTable)
          ..where((tbl) => tbl.taskId.equals(taskId) & tbl.tagId.equals(tagId)))
        .go();
  }
}
