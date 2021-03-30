import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/subtask/subtask_remote_source.dart';
import 'package:diana/data/data_sources/tag/tag_remote_source.dart';
import 'package:diana/data/data_sources/task/task_local_source.dart';
import 'package:diana/data/data_sources/task/task_remote_source.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_local_source.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_remote_source.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:diana/domain/repos/task_repo.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:diana/injection_container.dart' as di;

class TaskRepoImpl extends TaskRepo {
  final NetWorkInfo netWorkInfo;
  final TaskRemoteSource taskRemoteSource;
  final TaskLocalSource taskLocalSource;
  final SubtaskRemoteSource subtaskRemoteSource;
  final TagRemoteSource tagRemoteSource;
  final TaskTagRemoteSource taskTagRemoteSource;
  final TaskTagLocalSoucre taskTagLocalSoucre;
  int taskOffset = 0, subtaskOffset = 0, tagOffset = 0;

  TaskRepoImpl({
    this.netWorkInfo,
    this.taskRemoteSource,
    this.taskLocalSource,
    this.subtaskRemoteSource,
    this.tagRemoteSource,
    this.taskTagRemoteSource,
    this.taskTagLocalSoucre,
  });

  @override
  Future<Either<Failure, bool>> deleteSubtask(String subtaskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await subtaskRemoteSource.deleteSubtask(subtaskId);

        log('API result is $result', name: 'deleteSubtask');

        await taskLocalSource.deleteSubTask(subtaskId);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.deleteTask(taskId);

        log('API result is $result', name: 'deleteTask');

        await FlutterLocalNotificationsPlugin().cancel(taskId.hashCode);

        await taskLocalSource.deleteTask(taskId);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTag(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await tagRemoteSource.deleteTag(id);

        log('API result is $result', name: 'deleteTag');

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  //TODO: MODIFY THESE Parameters
  @override
  Future<Either<Failure, bool>> deleteTaskTag(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskTagRemoteSource.deleteTaskTag(id);

        log('API result is $result', name: 'deleteTaskTag');

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, SubtaskResult>> editSubtask(
      String subtaskId, String name, bool isDone, String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await subtaskRemoteSource.editSubtask(
            subtaskId, name, isDone, taskId);

        log('API result is $result', name: 'editSubtask');

        await taskLocalSource.insertSubTask(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          SubtaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TagResult>> editTag(
      String id, String name, int color) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await tagRemoteSource.editTag(id, name, color);

        log('API result is $result', name: 'editTag');

        await taskLocalSource.insertTag(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskResult>> editTask(
    String taskId,
    String name,
    String note,
    String date,
    List<String> tags,
    List<String> checklist,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.editTask(taskId, name, note, tags,
            checklist, date, reminder, deadline, priority, done);

        log('API result is $result', name: 'editTask');

        if (result.reminder != null) {
          await di.sl<FlutterLocalNotificationsPlugin>().zonedSchedule(
                result.taskId.hashCode,
                result.name,
                result.note,
                tz.TZDateTime.parse(tz.local, result.reminder),
                di.sl.get(instanceName: taskNotificationInjectionName),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
              );
        }

        await taskLocalSource.insertTask(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  /// TODO: DELETE THIS
  @override
  Future<Either<Failure, TaskTagResponse>> editTaskTag(
      String id, String taskId, String tagId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskTagRemoteSource.editTaskTag(id, taskId, tagId);

        log('API result is $result', name: 'editTaskTag');

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TaskTagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, SubtaskResponse>> getSubtasks(String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        if (subtaskOffset != null) {
          final result =
              await subtaskRemoteSource.getSubtasks(taskId, subtaskOffset);

          log('API result is ${result.results}', name: 'getSubtasks');
          if (subtaskOffset == 0) {
            await taskLocalSource.deleteAndInsertSubTasks(result);
          } else {
            await taskLocalSource.insertSubTasks(result);
          }

          final offset = API.offsetExtractor(result.next);

          subtaskOffset = offset;
          return Right(result);
        } else {
          return Right(null);
          //TODO: return Left(NoMoreResultsfailure)
        }
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TagResponse>> getTags() async {
    if (await netWorkInfo.isConnected()) {
      try {
        if (tagOffset != null) {
          final result = await tagRemoteSource.getTags(tagOffset);

          log('API result is ${result.results}', name: 'getTags');

          if (tagOffset == 0) {
            await taskLocalSource.deleteAndInsertTags(result);
          } else {
            await taskLocalSource.insertTags(result);
          }

          final offset = API.offsetExtractor(result.next);

          tagOffset = offset;

          return Right(result);
        } else {
          return Right(null);
          //TODO: return Left(NoMoreResultsFailure)
        }
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskResponse>> getTasks() async {
    if (await netWorkInfo.isConnected()) {
      try {
        if (taskOffset != null) {
          final result = await taskRemoteSource.getTasks(taskOffset);

          log('API result is ${result.results}', name: 'getTasks');

          if (taskOffset == 0) {
            await taskLocalSource.deleteAndinsertTasks(result);
          } else {
            await taskLocalSource.insertTasks(result);
          }
          final offset = API.offsetExtractor(result.next);

          taskOffset = offset;

          return Right(result);
        } else {
          return Right(null);
          //TODO: return Left(NoMoreResultsFailure)
        }
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, SubtaskResult>> insertSubtask(
      String name, bool isDone, String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await subtaskRemoteSource.insertSubtask(name, isDone, taskId);

        log('API result is $result', name: 'insertSubtask');

        await taskLocalSource.insertSubTask(result);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          SubtaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TagResult>> insertTag(String name, int color) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await tagRemoteSource.insertTags(name, color);

        log('API result is $result', name: 'insertTag');

        await taskLocalSource.insertTag(result);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          TagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskResult>> insertTask(
    String name,
    String note,
    String date,
    List<String> tags,
    List<String> checklist,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.insertTask(name, note, tags,
            checklist, date, reminder, deadline, priority, done);

        log('API result is $result', name: 'insertTask');

        if (result.reminder != null) {
          print('reminder scheduled at ${result.reminder}');
          await di.sl<FlutterLocalNotificationsPlugin>().zonedSchedule(
                result.taskId.hashCode,
                result.name,
                result.note,
                tz.TZDateTime.parse(tz.local, result.reminder),
                di.sl.get(instanceName: taskNotificationInjectionName),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
              );
        }

        await taskLocalSource.insertTask(result);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          TaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  //TODO: DELETE THIS
  @override
  Future<Either<Failure, TaskTagResponse>> insertTaskTag(
      String taskId, String tagId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskTagRemoteSource.insertTaskTag(taskId, tagId);

        log('API result is $result', name: 'insertTaskTag');

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          TaskTagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  Stream<List<TaskWithSubtasks>> watchTodayTasks(List<String> tags) {
    return taskLocalSource.watchTodayTasks(kUserId, tags);
  }

  Stream<List<TaskWithSubtasks>> watchAllTasks(List<String> tags) {
    return taskLocalSource.watchAllTasks(kUserId, tags);
  }

  Stream<List<TaskWithSubtasks>> watchCompletedTasks(List<String> tags) {
    return taskLocalSource.watchCompletedTasks(kUserId, tags);
  }

  Stream<List<TaskWithSubtasks>> watchMissedTasks(List<String> tags) {
    return taskLocalSource.watchMissedTasks(kUserId, tags);
  }

  @override
  Stream<List<TagData>> watchAllTags() {
    return taskLocalSource.watchAllTags(kUserId);
  }

  @override
  Stream<TaskWithTags> watchTagsForTask(String taskId) {
    return taskLocalSource.watchTagsForTask(kUserId, taskId);
  }

  @override
  Future<Either<Failure, TaskResult>> makeTaskDone(String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.makeTaskDone(taskId);

        log('API result is $result', name: 'makeTaskDone');

        await taskLocalSource.insertTask(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
