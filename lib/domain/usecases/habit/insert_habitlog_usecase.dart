import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class InsertHabitLogUseCase {
  final HabitRepo habitRepo;

  InsertHabitLogUseCase({this.habitRepo});

  Future<Either<Failure, HabitlogResult>> call(String habitId) {
    return habitRepo.insertHabitlog(habitId);
  }
}
