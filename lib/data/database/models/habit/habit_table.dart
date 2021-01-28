import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('HabitData')
class HabitTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get name => text()();
  // TextColumn get days => text().map(DaysConverter())();
  TextColumn get time => text()();

  @override
  String get tableName => 'habit_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<HabitTableCompanion> fromHabitResponse(List<HabitResult> habits) {
    return habits.map((habit) {
      // final days = Day(days: habit.days);
      return HabitTableCompanion(
        id: Value(habit.habitId),
        userId: Value(habit.userId),
        name: Value(habit.name),
        // days: Value(days),
        time: Value(habit.time),
      );
    }).toList();
  }

  static HabitTableCompanion fromHabitResult(HabitResult habit) {
    return HabitTableCompanion(
      id: Value(habit.habitId),
      userId: Value(habit.userId),
      name: Value(habit.name),
      // days: Value(days),
      time: Value(habit.time),
    );
  }
}
