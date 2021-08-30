import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/domain/repos/task_repo.dart';

class EditSubTaskUseCase {
  final TaskRepo? taskRepo;

  EditSubTaskUseCase({this.taskRepo});

  Future<Either<Failure, SubtaskResult>> call(
    String subtaskId,
    String name,
    bool isDone,
    String taskId,
  ) {
    return taskRepo!.editSubtask(subtaskId, name, isDone, taskId);
  }
}
