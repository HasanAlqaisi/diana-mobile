import 'package:moor/moor.dart';

import 'package:diana/data/database/models/habit/habit_dao.dart';
import 'package:diana/data/database/models/habit_log/habitlog_dao.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';

abstract class HabitLocalSource {
  Future<void> deleteAndinsertHabits(HabitResponse habits);

  Future<void> insertHabits(HabitResponse habits);

  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(
      String? userId, int todayInt);

  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits(String? userId);

  Future<void> insertHabit(HabitResult habit);

  Future<int> deleteHabit(String habitId);

  Future<void> deleteAndinsertHabitlogs(List<HabitResult>? habitlogs);

  Future<void> insertHabitlogs(List<HabitResult>? habitlogs);

  Future<void> insertHabitlog(HabitResult habitlog);
}

class HabitLocalSourceImpl extends HabitLocalSource {
  final HabitDao? habitDao;
  final HabitlogDao? habitlogDao;

  HabitLocalSourceImpl({
    this.habitDao,
    this.habitlogDao,
  });

  @override
  Future<void> deleteAndinsertHabits(HabitResponse habits) {
    try {
      return habitDao!.deleteAndinsertHabits(habits);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertHabits(HabitResponse habits) {
    try {
      return habitDao!.insertHabits(habits);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits(String? userId) {
    return habitDao!.watchAllHabits(userId);
  }

  @override
  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(
      String? userId, int todayInt) {
    return habitDao!.watchTodayHabits(userId, todayInt);
  }

  @override
  Future<int> deleteHabit(String habitId) {
    return habitDao!.deleteHabit(habitId);
  }

  @override
  Future<void> insertHabit(HabitResult habit) {
    try {
      return habitDao!.insertHabit(habit);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAndinsertHabitlogs(List<HabitResult>? habitResults) {
    try {
      return habitlogDao!.deleteAndinsertHabitlogs(habitResults);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertHabitlog(HabitResult habitResult) {
    try {
      return habitlogDao!.insertHabitlogs([habitResult]);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertHabitlogs(List<HabitResult>? habitResults) {
    try {
      return habitlogDao!.insertHabitlogs(habitResults);
    } on InvalidDataException {
      rethrow;
    }
  }
}
