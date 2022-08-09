import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/habit_log/habitlog_table.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:drift/drift.dart';

part 'habitlog_dao.g.dart';

@DriftAccessor(tables: [HabitlogTable])
class HabitlogDao extends DatabaseAccessor<AppDatabase>
    with _$HabitlogDaoMixin {
  HabitlogDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertHabitlogs(List<HabitResult>? habitResults) async {
    return transaction(() async {
      // Clear the tables associated with habitlog
      await delete(habitlogTable).go();
      // Insert data for habitlog
      await batch((batch) {
        batch.insertAll(
            habitlogTable, HabitlogTable.fromHabitResults(habitResults),
            mode: InsertMode.replace);
      });
    });
  }

  Future<void> insertHabitlogs(List<HabitResult>? habitResults) async {
    return transaction(() async {
      // Insert data for habit
      await batch((batch) {
        batch.insertAll(
            habitlogTable, HabitlogTable.fromHabitResults(habitResults),
            mode: InsertMode.replace);
      });
    });
  }

  // Future<void> insertHabitlog(HabitResult habitlog) async {
  //   return transaction(() async {
  //     // Insert data for habit
  //     await batch((batch) {
  //       batch.insert(habitlogTable, HabitlogTable.fromHabitResult(habitlog));
  //     });
  //   });
  // }
}
