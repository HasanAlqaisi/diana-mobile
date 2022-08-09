import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:drift/drift.dart';

import 'package:diana/data/database/models/subtask/subtask_dao.dart';
import 'package:diana/data/database/models/tag/tag_dao.dart';
import 'package:diana/data/database/models/task/task_dao.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

abstract class TaskLocalSource {
  Future<void> deleteAndinsertTasks(
    TaskResponse taskResponse,
  );

  Future<void> insertTasks(TaskResponse taskResponse);

  Stream<List<TaskWithSubtasks>> watchTodayTasks(
      String? userId, List<String> tags);

  Stream<List<TaskWithSubtasks>> watchAllTasks(
      String? userId, List<String> tags);

  Stream<List<TaskWithSubtasks>> watchCompletedTasks(
      String? userId, List<String> tags);

  Stream<List<TaskWithSubtasks>> watchMissedTasks(
      String? userId, List<String> tags);

  Stream<List<TagData>> watchAllTags(String? userId);

  Future<int> deleteTag(String tagId);

  Future<int> insertTag(TagResult tagResult);

  Future<int> deleteTask(String taskId);

  Future<void> insertTask(TaskResult taskResult);

  Future<int> deleteSubTask(String subtaskId);

  Future<int> insertSubTask(SubtaskResult subtaskResult);

  Future<void> deleteAndInsertSubTasks(SubtaskResponse subtaskResponse);

  Future<void> insertSubTasks(SubtaskResponse subtaskResponse);

  Future<void> deleteAndInsertTags(TagResponse tagResponse);

  Future<void> insertTags(TagResponse tagResponse);

  Stream<TaskWithTags> watchTagsForTask(String? userId, String taskId);
}

class TaskLocalSourceImpl extends TaskLocalSource {
  final TaskDao? taskDao;
  final TagDao? tagDao;
  final SubTaskDao? subTaskDao;

  TaskLocalSourceImpl({
    this.taskDao,
    this.tagDao,
    this.subTaskDao,
  });

  @override
  Future<void> deleteAndinsertTasks(
    TaskResponse taskResponse,
  ) {
    try {
      return taskDao!.deleteAndinsertTasks(taskResponse);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertTasks(TaskResponse taskResponse) {
    try {
      return taskDao!.insertTasks(taskResponse);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<TaskWithSubtasks>> watchAllTasks(
      String? userId, List<String> tags) {
    return taskDao!.watchAllTasks(userId, tags);
  }

  @override
  Stream<List<TaskWithSubtasks>> watchCompletedTasks(
      String? userId, List<String> tags) {
    return taskDao!.watchCompletedTasks(userId, tags);
  }

  @override
  Stream<List<TaskWithSubtasks>> watchMissedTasks(
      String? userId, List<String> tags) {
    return taskDao!.watchMissedTasks(userId, tags);
  }

  @override
  Stream<List<TaskWithSubtasks>> watchTodayTasks(
      String? userId, List<String> tags) {
    return taskDao!.watchTodayTasks(userId, tags);
  }

  @override
  Future<int> deleteTag(String tagId) {
    return tagDao!.deleteTag(tagId);
  }

  @override
  Future<int> insertTag(TagResult tagResult) {
    try {
      return tagDao!.insertTag(tagResult);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<int> deleteTask(String taskId) {
    return taskDao!.deleteTask(taskId);
  }

  @override
  Future<void> insertTask(TaskResult taskResult) {
    return taskDao!.insertTask(taskResult);
  }

  @override
  Future<int> deleteSubTask(String subtaskId) {
    return subTaskDao!.deleteSubTask(subtaskId);
  }

  @override
  Future<int> insertSubTask(SubtaskResult subtaskResult) {
    return subTaskDao!.insertSubTask(subtaskResult);
  }

  @override
  Future<void> deleteAndInsertSubTasks(SubtaskResponse subtaskResponse) {
    try {
      return subTaskDao!.deleteAndinsertSubTasks(subtaskResponse);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertSubTasks(SubtaskResponse subtaskResponse) {
    try {
      return subTaskDao!.insertSubTasks(subtaskResponse);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAndInsertTags(TagResponse tagResponse) {
    try {
      return tagDao!.deleteAndinsertTags(tagResponse);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertTags(TagResponse tagResponse) {
    try {
      return tagDao!.insertTags(tagResponse);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<TagData>> watchAllTags(String? userId) {
    return taskDao!.watchAllTags(userId);
  }

  @override
  Stream<TaskWithTags> watchTagsForTask(String? userId, String taskId) {
    return taskDao!.watchTagsForClass(userId, taskId);
  }
}
