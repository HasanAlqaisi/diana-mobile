import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class GetHabitLogsUseCase {
  final HabitRepo habitRepo;

  GetHabitLogsUseCase({this.habitRepo});

  Future<Either<Failure, HabitlogResponse>> call(String habitId) {
    return habitRepo.getHabitlogs(habitId);
  }
}
