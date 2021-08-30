import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class InsertHabitUseCase {
  final HabitRepo? habitRepo;

  InsertHabitUseCase({this.habitRepo});

  Future<Either<Failure, HabitResult>> call(
      String name, List<int>? days, String? time) {
    return habitRepo!.insertHabit(name, days, time);
  }
}
