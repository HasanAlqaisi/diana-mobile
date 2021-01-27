import 'package:diana/data/database/models/habit/days_table.dart';
import 'package:diana/data/database/models/habit/habit_table.dart';
import 'package:diana/data/database/models/habit_log/habitlog_table.dart';
import 'package:diana/data/database/models/subtask/subtask_table.dart';
import 'package:diana/data/database/models/tag/tag_table.dart';
import 'package:diana/data/database/models/task/task_table.dart';
import 'package:diana/data/database/models/tasktag/tasktag_table.dart';
import 'package:diana/data/database/models/user/user_table.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

@UseMoor(
  tables: [
    HabitTable,
    HabitlogTable,
    DaysTable,
    SubTaskTable,
    TagTable,
    TaskTable,
    TaskTagTable,
    UserTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor q) : super(q);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });
}
