import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/domain/repos/task_repo.dart';

class GetTasksUseCase {
  final TaskRepo taskRepo;

  GetTasksUseCase({this.taskRepo});

  Future<Either<Failure, TaskResponse>> call() {
    return taskRepo.getTasks();
  }
}
