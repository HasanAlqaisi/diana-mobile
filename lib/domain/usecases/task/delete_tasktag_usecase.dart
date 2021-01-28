import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/task_repo.dart';

class DeleteTasktagUseCase {
  final TaskRepo taskRepo;

  DeleteTasktagUseCase({this.taskRepo});

  Future<Either<Failure, bool>> call(String id) {
    return taskRepo.deleteTaskTag(id);
  }
}
