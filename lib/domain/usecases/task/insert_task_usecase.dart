import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/domain/repos/task_repo.dart';

class InsertTaskUseCase {
  final TaskRepo? taskRepo;

  InsertTaskUseCase({this.taskRepo});

  Future<Either<Failure, TaskResult>> call(
    String name,
    String? note,
    String? date,
    List<String>? tags,
    List<String?>? checklist,
    String? reminder,
    String? deadline,
    int? priority,
    bool? done,
  ) {
    return taskRepo!.insertTask(
        name, note, date, tags, checklist, reminder, deadline, priority, done);
  }
}
