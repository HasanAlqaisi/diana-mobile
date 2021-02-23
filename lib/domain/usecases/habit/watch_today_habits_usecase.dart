import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class WatchTodayHabitUseCase {
  final HabitRepo habitRepo;

  WatchTodayHabitUseCase(this.habitRepo);

  Stream<Future<List<HabitWitLogsWithDays>>> call(int day) {
    return habitRepo.watchTodayHabits(day);
  }
}
