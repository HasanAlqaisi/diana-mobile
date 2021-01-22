import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';

abstract class HabitRepo {
  Future<Either<Failure, HabitResponse>> getHabits(int offset);

  Future<Either<Failure, HabitResult>> insertHabit(
    String name,
    List<int> days,
    String time,
  );

  Future<Either<Failure, HabitResult>> editHabit(
    String habitId,
    String name,
    List<int> days,
    String time,
  );

  Future<Either<Failure, bool>> deleteHabit(String habitId);

  Future<Either<Failure, HabitlogResponse>> getHabitlogs(
    int offset,
    String habitId,
  );

  Future<Either<Failure, HabitlogResult>> insertHabitlog(
    String habitId,
  );
}
