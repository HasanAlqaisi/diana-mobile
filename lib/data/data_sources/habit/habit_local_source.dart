import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'package:diana/data/database/models/habit/habit_dao.dart';
import 'package:diana/data/database/models/habit_log/habitlog_dao.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';

abstract class HabitLocalSource {
  Future<void> deleteAndinsertHabits(HabitResponse habits);

  Future<void> insertHabits(HabitResponse habits);

  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(
      String userId, int todayInt);

  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits(String userId);

  Future<void> insertHabit(HabitResult habit);

  Future<int> deleteHabit(String habitId);

  Future<void> deleteAndinsertHabitlogs(HabitlogResponse habitlogs);

  Future<void> insertHabitlogs(HabitlogResponse habitlogs);

  Future<void> insertHabitlog(HabitlogResult habitlog);
}

class HabitLocalSourceImpl extends HabitLocalSource {
  final HabitDao habitDao;
  final HabitlogDao habitlogDao;

  HabitLocalSourceImpl({
    this.habitDao,
    this.habitlogDao,
  });

  @override
  Future<void> deleteAndinsertHabits(HabitResponse habits) {
    try {
      return habitDao.deleteAndinsertHabits(habits);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertHabits(HabitResponse habits) {
    try {
      return habitDao.insertHabits(habits);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits(String userId) {
    return habitDao.watchAllHabits(userId);
  }

  @override
  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(
      String userId, int todayInt) {
    return habitDao.watchTodayHabits(userId, todayInt);
  }

  @override
  Future<int> deleteHabit(String habitId) {
    return habitDao.deleteHabit(habitId);
  }

  @override
  Future<void> insertHabit(HabitResult habit) {
    try {
      return habitDao.insertHabit(habit);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAndinsertHabitlogs(HabitlogResponse habitlogs) {
    try {
      return habitlogDao.deleteAndinsertHabitlogs(habitlogs);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertHabitlog(HabitlogResult habitlog) {
    try {
      return habitlogDao.insertHabitlog(habitlog);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertHabitlogs(HabitlogResponse habitlogs) {
    try {
      return habitlogDao.insertHabitlogs(habitlogs);
    } on InvalidDataException {
      rethrow;
    }
  }
}
