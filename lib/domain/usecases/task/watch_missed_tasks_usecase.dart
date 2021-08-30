import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/domain/repos/task_repo.dart';

class WatchMissedTasksUseCase {
  final TaskRepo? taskRepo;

  WatchMissedTasksUseCase(this.taskRepo);

  Stream<List<TaskWithSubtasks>> call(List<String> tags) {
    return taskRepo!.watchMissedTasks(tags);
  }
}
