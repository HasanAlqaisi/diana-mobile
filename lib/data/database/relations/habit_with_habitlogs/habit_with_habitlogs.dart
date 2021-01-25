import 'package:diana/data/database/app_database/app_database.dart';

///one-to-many relationship
class HabitWithHabitLogs {
  final HabitData habit;
  final List<HabitlogData> habitLogs;

  HabitWithHabitLogs({this.habit, this.habitLogs});

  @override
  String toString() {
    return '''   habit info: ${habit.name}
    habitLogs info: $habitLogs
    ''';
  }
}
