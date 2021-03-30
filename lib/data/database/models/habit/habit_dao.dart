import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/habit/days_table.dart';
import 'package:diana/data/database/models/habit/habit_table.dart';
import 'package:diana/data/database/models/habit_log/habitlog_table.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:moor/moor.dart';

part 'habit_dao.g.dart';

/// [HabitlogTable] contains the logs of the week
/// [DaysTable] contains the days that this habit schedualed
@UseDao(tables: [HabitTable, HabitlogTable, DaysTable])
class HabitDao extends DatabaseAccessor<AppDatabase> with _$HabitDaoMixin {
  HabitDao(AppDatabase db) : super(db);

  Future<void> deleteAndinsertHabits(HabitResponse habits) async {
    return transaction(() async {
      // Clear the tables associated with habit
      await delete(habitTable).go();
      await delete(daysTable).go();
      // Insert data for habit, days
      await batch((batch) {
        batch.insertAll(
            habitTable, HabitTable.fromHabitResponse(habits.results),
            mode: InsertMode.replace);
        batch.insertAll(daysTable, DaysTable.fromHabitResponse(habits.results),
            mode: InsertMode.replace);
      });
    });
  }

  Future<void> insertHabits(HabitResponse habits) async {
    return transaction(() async {
      // Insert data for habit, days
      await batch((batch) {
        batch.insertAll(
            habitTable, HabitTable.fromHabitResponse(habits.results),
            mode: InsertMode.replace);
        batch.insertAll(daysTable, DaysTable.fromHabitResponse(habits.results),
            mode: InsertMode.replace);
      });
    });
  }

  Future<void> insertHabit(HabitResult habit) async {
    return transaction(() async {
      // Insert data for habit, days
      await batch((batch) {
        batch.insert(habitTable, HabitTable.fromHabitResult(habit),
            mode: InsertMode.replace);
        batch.insert(daysTable, DaysTable.fromHabitResult(habit),
            mode: InsertMode.replace);
      });
    });
  }

  Future<int> deleteHabit(String habitId) async {
    return (delete(habitTable)..where((tbl) => tbl.id.equals(habitId))).go();
  }

  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(
      String userId, int todayInt) {

    return ((select(habitTable)..where((tbl) => tbl.userId.equals(userId)))
            .join([
      leftOuterJoin(
          habitlogTable, habitlogTable.habitId.equalsExp(habitTable.id)),
      leftOuterJoin(daysTable, daysTable.habitId.equalsExp(habitTable.id))
    ])

              /// Check if the current weekday is somewhere in daystable
              ..where((daysTable.dayZero.equals(todayInt) |
                  daysTable.dayOne.equals(todayInt) |
                  daysTable.dayTwo.equals(todayInt) |
                  daysTable.dayThree.equals(todayInt) |
                  daysTable.dayFour.equals(todayInt) |
                  daysTable.dayFive.equals(todayInt) |
                  daysTable.daySix.equals(todayInt))))
        .watch()
        .map((rows) async {
      final result = <HabitData, List<HabitlogData>>{};
      for (final row in rows) {
        final habit = row.readTable(habitTable);
        final habitLog = row.readTable(habitlogTable);

        final list = result.putIfAbsent(habit, () => []);
        if (habitLog != null) list.add(habitLog);
      }
      return [
        for (final entry in result.entries)
          HabitWitLogsWithDays(
            habit: entry.key,
            habitLogs: entry.value,
            days: await (select(daysTable)
                  ..where((tbl) => tbl.habitId.equals(entry.key.id)))
                .getSingle(),
          )
      ];
    });
  }

  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits(String userId) {

    return ((select(habitTable)..where((tbl) => tbl.userId.equals(userId)))
        .join([
          leftOuterJoin(
              habitlogTable, habitlogTable.habitId.equalsExp(habitTable.id)),
          leftOuterJoin(daysTable, daysTable.habitId.equalsExp(habitTable.id))
        ])
        .watch()
        .map((rows) async {
          final result = <HabitData, List<HabitlogData>>{};
          for (final row in rows) {
            final habit = row.readTable(habitTable);
            final habitLog = row.readTable(habitlogTable);

            final list = result.putIfAbsent(habit, () => []);
            if (habitLog != null) list.add(habitLog);
          }
          return [
            for (final entry in result.entries)
              HabitWitLogsWithDays(
                habit: entry.key,
                habitLogs: entry.value,
                days: await (select(daysTable)
                      ..where((tbl) => tbl.habitId.equals(entry.key.id)))
                    .getSingle(),
              )
          ];
        }));
  }
}
