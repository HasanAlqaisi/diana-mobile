import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/domain/repos/task_repo.dart';

class MakeTaskDoneUseCase {
  final TaskRepo taskRepo;

  MakeTaskDoneUseCase({this.taskRepo});

  Future<Either<Failure, TaskResult>> call(String taskId) {
    return taskRepo.makeTaskDone(taskId);
  }
}
