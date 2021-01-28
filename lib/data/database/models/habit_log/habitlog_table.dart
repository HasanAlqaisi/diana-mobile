import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('HabitlogData')
class HabitlogTable extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().customConstraint('REFERENCES habit_table(id)')();
  DateTimeColumn get doneAt => dateTime()();

  @override
  String get tableName => 'habitlog_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<HabitlogTableCompanion> fromHabitlogResponse(
      List<HabitlogResult> habitlogs) {
    return habitlogs
        .map((habitlog) => HabitlogTableCompanion(
              id: Value(habitlog.habitlogId),
              habitId: Value(habitlog.habitId),
              doneAt: Value(habitlog.doneAt != null
                  ? DateTime.tryParse(habitlog.doneAt)
                  : null),
            ))
        .toList();
  }

  static HabitlogTableCompanion fromHabitlogResult(HabitlogResult habitlog) {
    return HabitlogTableCompanion(
      id: Value(habitlog.habitlogId),
      habitId: Value(habitlog.habitId),
      doneAt: Value(
          habitlog.doneAt != null ? DateTime.tryParse(habitlog.doneAt) : null),
    );
  }
}
