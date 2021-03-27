import 'package:diana/data/database/app_database/app_database.dart';

///one-to-many relationship betwwen habit and logs
/// one-to-one relationship between habit and days
class HabitWitLogsWithDays {
  final HabitData habit;
  List<HabitlogData> habitLogs;
  HabitDoneDays doneDays;
  final DaysData days;

  HabitWitLogsWithDays({this.habit, this.habitLogs, this.days});

  @override
  String toString() {
    return '''   habit info: ${habit.name}
    habitLogs info: $habitLogs
    days info: $days
    ''';
  }
}

class HabitDoneDays {
  List<int> weekDays = [];
}
