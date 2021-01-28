import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class EditHabitUseCase {
  final HabitRepo habitRepo;

  EditHabitUseCase({this.habitRepo});

  Future<Either<Failure, HabitResult>> call(
    String habitId,
    String name,
    List<int> days,
    String time,
  ) {
    return habitRepo.editHabit(habitId, name, days, time);
  }
}
