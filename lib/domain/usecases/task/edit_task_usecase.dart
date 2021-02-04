import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/domain/repos/task_repo.dart';

class EditTaskUseCase {
  final TaskRepo taskRepo;

  EditTaskUseCase({this.taskRepo});

  Future<Either<Failure, TaskResult>> call(
    String taskId,
    String name,
    String note,
    String date,
    List<String> tags,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) {
    return taskRepo.editTask(
        taskId, name, note, date, tags, reminder, deadline, priority, done);
  }
}
