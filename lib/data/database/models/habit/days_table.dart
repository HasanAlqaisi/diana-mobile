import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('DaysData')
class DaysTable extends Table {
  TextColumn get habitId =>
      text().customConstraint('REFERENCES habit_table(id)')();
  IntColumn get dayZero => integer().nullable()();
  IntColumn get dayOne => integer().nullable()();
  IntColumn get dayTwo => integer().nullable()();
  IntColumn get dayThree => integer().nullable()();
  IntColumn get dayFour => integer().nullable()();
  IntColumn get dayFive => integer().nullable()();
  IntColumn get daySix => integer().nullable()();

  @override
  String get tableName => 'days_table';

  @override
  Set<Column> get primaryKey => {habitId};

  static List<DaysTableCompanion> fromHabitResponse(List<HabitResult> habits) {
    return habits.map((habit) {
      return DaysTableCompanion(
        habitId: Value(habit.habitId),
        dayZero: Value(habit.days[0]),
        dayOne: Value(habit.days[1]),
        dayTwo: Value(habit.days[2]),
        dayThree: Value(habit.days[3]),
        dayFour: Value(habit.days[4]),
        dayFive: Value(habit.days[5]),
        daySix: Value(habit.days[6]),
      );
    }).toList();
  }

  static DaysTableCompanion fromHabitResult(HabitResult habit) {
    return DaysTableCompanion(
      habitId: Value(habit.habitId),
      dayZero: Value(habit.days[0]),
      dayOne: Value(habit.days[1]),
      dayTwo: Value(habit.days[2]),
      dayThree: Value(habit.days[3]),
      dayFour: Value(habit.days[4]),
      dayFive: Value(habit.days[5]),
      daySix: Value(habit.days[6]),
    );
  }
}
