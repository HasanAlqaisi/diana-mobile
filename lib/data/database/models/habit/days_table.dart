import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('DaysData')
class DaysTable extends Table {
  TextColumn get habitId =>
      text().customConstraint('REFERENCES habit_table(id) ON DELETE CASCADE')();
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
      int lastIndex = habit.days.length-1;
      return DaysTableCompanion(
        habitId: Value(habit.habitId),
        dayZero: Value(lastIndex >= 0 ? habit.days[0] : null),
        dayOne: Value(lastIndex >= 1 ? habit.days[1] : null),
        dayTwo: Value(lastIndex >= 2 ? habit.days[2] : null),
        dayThree: Value(lastIndex >= 3 ? habit.days[3] : null),
        dayFour: Value(lastIndex >= 4 ? habit.days[4] : null),
        dayFive: Value(lastIndex >= 5 ? habit.days[5] : null),
        daySix: Value(lastIndex >= 6 ? habit.days[6] : null),
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
