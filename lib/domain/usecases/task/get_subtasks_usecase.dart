import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/domain/repos/task_repo.dart';

class GetSubtasksUseCase {
  final TaskRepo taskRepo;

  GetSubtasksUseCase({this.taskRepo});

  Future<Either<Failure, SubtaskResponse>> call(String taskId) {
    return taskRepo.getSubtasks(taskId);
  }
}
