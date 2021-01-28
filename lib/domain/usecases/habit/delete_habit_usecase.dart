import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class DeleteHabitUseCase {
  final HabitRepo habitRepo;

  DeleteHabitUseCase({this.habitRepo});

  Future<Either<Failure, bool>> call(String habitId) {
    return habitRepo.deleteHabit(habitId);
  }
}
