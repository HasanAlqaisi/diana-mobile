import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/task_repo.dart';

class DeleteTaskUseCase {
  final TaskRepo taskRepo;

  DeleteTaskUseCase({this.taskRepo});

  Future<Either<Failure, bool>> call(String taskId) {
    return taskRepo.deleteTask(taskId);
  }
}
