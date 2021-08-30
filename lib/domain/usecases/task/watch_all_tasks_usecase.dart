import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/domain/repos/task_repo.dart';

class WatchAllTasksUseCase {
  final TaskRepo? taskRepo;

  WatchAllTasksUseCase(this.taskRepo);

  Stream<List<TaskWithSubtasks>> call(List<String> tags) {
    return taskRepo!.watchAllTasks(tags);
  }
}
