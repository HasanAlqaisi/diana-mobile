import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('HabitlogData')
class HabitlogTable extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().customConstraint('REFERENCES habit_table(id) ON DELETE CASCADE')();
  DateTimeColumn get doneAt => dateTime()();

  @override
  String get tableName => 'habitlog_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<HabitlogTableCompanion> fromHabitResults(
      List<HabitResult> habitResults) {
    List<HabitlogTableCompanion> histories = [];
    habitResults?.forEach((habit) {
      habit?.history?.forEach((history) {
        histories.add(HabitlogTableCompanion(
          id: Value(history.habitlogId),
          habitId: Value(history.habitId),
          doneAt: Value(history.doneAt != null
              ? DateTime.tryParse(history.doneAt)
              : null),
        ));
      });
    });
    return histories;
  }

  static List<HabitlogTableCompanion> fromHabitResult(HabitResult habitResult) {
    List<HabitlogTableCompanion> histories = [];
    habitResult.history.map((history) => histories.add(HabitlogTableCompanion(
          id: Value(history.habitlogId),
          habitId: Value(history.habitId),
          doneAt: Value(history.doneAt != null
              ? DateTime.tryParse(history.doneAt)
              : null),
        )));

    return histories;
  }
}
