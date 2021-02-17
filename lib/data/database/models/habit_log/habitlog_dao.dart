import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/habit_log/habitlog_table.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'habitlog_dao.g.dart';

@UseDao(tables: [HabitlogTable])
class HabitlogDao extends DatabaseAccessor<AppDatabase>
    with _$HabitlogDaoMixin {
  HabitlogDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertHabitlogs(HabitlogResponse habitlogs) async {
    return transaction(() async {
      // Clear the tables associated with habitlog
      await delete(habitlogTable).go();
      // Insert data for habitlog
      await batch((batch) {
        batch.insertAll(habitlogTable,
            HabitlogTable.fromHabitlogResponse(habitlogs.results),
            mode: InsertMode.replace);
      });
    });
  }

  Future<void> insertHabitlogs(HabitlogResponse habitlogs) async {
    return transaction(() async {
      // Insert data for habit
      await batch((batch) {
        batch.insertAll(habitlogTable,
            HabitlogTable.fromHabitlogResponse(habitlogs.results),
            mode: InsertMode.replace);
      });
    });
  }

  Future<void> insertHabitlog(HabitlogResult habitlog) async {
    return transaction(() async {
      // Insert data for habit
      await batch((batch) {
        batch.insert(habitlogTable, HabitlogTable.fromHabitlogResult(habitlog));
      });
    });
  }
}
