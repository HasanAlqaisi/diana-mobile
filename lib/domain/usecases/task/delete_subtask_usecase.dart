import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/task_repo.dart';

class DeleteSubTaskUseCase {
  final TaskRepo taskRepo;

  DeleteSubTaskUseCase({this.taskRepo});

  Future<Either<Failure, bool>> call(String subtaskId) {
    return taskRepo.deleteSubtask(subtaskId);
  }
}
