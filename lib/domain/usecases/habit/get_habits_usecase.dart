import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class GetHabitsUseCase {
  final HabitRepo habitRepo;

  GetHabitsUseCase({this.habitRepo});

  Future<Either<Failure, HabitResponse>> call() {
    return habitRepo.getHabits();
  }
}
