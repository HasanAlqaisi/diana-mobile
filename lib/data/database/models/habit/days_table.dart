import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:moor/moor.dart';

@DataClassName('DaysData')
class DaysTable extends Table {
  TextColumn get habitId => text().customConstraint(
      'REFERENCES habit_table(id) ON DELETE CASCADE ON UPDATE CASCADE')();
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
    return habits?.map((habit) {
      int lastIndex =
          habit?.days?.length == null ? null : habit.days.length - 1;
      return DaysTableCompanion(
        habitId: Value(habit.habitId),
        dayZero:
            Value(lastIndex != null && lastIndex >= 0 ? habit.days[0] : null),
        dayOne:
            Value(lastIndex != null && lastIndex >= 1 ? habit.days[1] : null),
        dayTwo:
            Value(lastIndex != null && lastIndex >= 2 ? habit.days[2] : null),
        dayThree:
            Value(lastIndex != null && lastIndex >= 3 ? habit.days[3] : null),
        dayFour:
            Value(lastIndex != null && lastIndex >= 4 ? habit.days[4] : null),
        dayFive:
            Value(lastIndex != null && lastIndex >= 5 ? habit.days[5] : null),
        daySix:
            Value(lastIndex != null && lastIndex >= 6 ? habit.days[6] : null),
      );
    })?.toList();
  }

  static DaysTableCompanion fromHabitResult(HabitResult habit) {
    int lastIndex = habit?.days?.length == null ? null : habit.days.length - 1;
    return DaysTableCompanion(
      habitId: Value(habit.habitId),
      dayZero:
          Value(lastIndex != null && lastIndex >= 0 ? habit.days[0] : null),
      dayOne: Value(lastIndex != null && lastIndex >= 1 ? habit.days[1] : null),
      dayTwo: Value(lastIndex != null && lastIndex >= 2 ? habit.days[2] : null),
      dayThree:
          Value(lastIndex != null && lastIndex >= 3 ? habit.days[3] : null),
      dayFour:
          Value(lastIndex != null && lastIndex >= 4 ? habit.days[4] : null),
      dayFive:
          Value(lastIndex != null && lastIndex >= 5 ? habit.days[5] : null),
      daySix: Value(lastIndex != null && lastIndex >= 6 ? habit.days[6] : null),
    );
  }
}
