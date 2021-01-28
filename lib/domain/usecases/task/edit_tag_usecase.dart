import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/task_repo.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

class EditTagUseCase {
  final TaskRepo taskRepo;

  EditTagUseCase({this.taskRepo});

  Future<Either<Failure, TagResult>> call(String id, String name, int color) {
    return taskRepo.editTag(id, name, color);
  }
}
