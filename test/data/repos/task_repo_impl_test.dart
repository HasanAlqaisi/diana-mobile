import 'dart:convert';

import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/subtask/subtask_remote_source.dart';
import 'package:diana/data/data_sources/tag/tag_remote_source.dart';
import 'package:diana/data/data_sources/task/task_local_source.dart';
import 'package:diana/data/data_sources/task/task_remote_source.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_remote_source.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:diana/data/repos/task_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

import '../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockTaskRemoteSource extends Mock implements TaskRemoteSource {}

class MockTaskLocalSource extends Mock implements TaskLocalSource {}

class MockSubtaskRemoteSource extends Mock implements SubtaskRemoteSource {}

class MockTagRemoteSource extends Mock implements TagRemoteSource {}

class MockTaskTagRemoteSource extends Mock implements TaskTagRemoteSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockSubtaskRemoteSource subtaskRemoteSource;
  MockTagRemoteSource tagRemoteSource;
  MockTaskRemoteSource taskRemoteSource;
  MockTaskLocalSource taskLocalSource;
  MockTaskTagRemoteSource taskTagRemoteSource;
  TaskRepoImpl repo;

  final taskResponse = TaskResponse.fromJson(json.decode(fixture('task.json')));
  final taskResult =
      TaskResult.fromJson(json.decode(fixture('task_result.json')));

  final subtaskResponse =
      SubtaskResponse.fromJson(json.decode(fixture('subtask.json')));
  final subtaskResult =
      SubtaskResult.fromJson(json.decode(fixture('subtask_result.json')));

  final tagResponse = TagResponse.fromJson(json.decode(fixture('tag.json')));
  final tagResult = TagResult.fromJson(json.decode(fixture('tag_result.json')));

  final taskTagResult =
      TaskTagResponse.fromJson(json.decode(fixture('tasktag.json')));

  final taskFieldsFailure = TaskFieldsFailure(name: ['name is not valid!']);

  final subtaskFieldsFailure =
      SubtaskFieldsFailure(done: ['done shoud not be true!']);

  final tagFieldsFailure =
      TagFieldsFailure(color: ['Color is not in the range!']);

  final taskTagFieldsFailure =
      TaskTagFieldsFailure(taskId: ['task id not valid!']);

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    taskRemoteSource = MockTaskRemoteSource();
    taskLocalSource = MockTaskLocalSource();
    subtaskRemoteSource = MockSubtaskRemoteSource();
    tagRemoteSource = MockTagRemoteSource();
    taskTagRemoteSource = MockTaskTagRemoteSource();

    repo = TaskRepoImpl(
      netWorkInfo: netWorkInfo,
      subtaskRemoteSource: subtaskRemoteSource,
      tagRemoteSource: tagRemoteSource,
      taskRemoteSource: taskRemoteSource,
      taskTagRemoteSource: taskTagRemoteSource,
      taskLocalSource: taskLocalSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('deleteSubtask', () {
      test('should user has an internet connection', () async {
        await repo.deleteSubtask('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(subtaskRemoteSource.deleteSubtask(''))
            .thenAnswer((_) async => true);

        final result = await repo.deleteSubtask('');

        expect(result, Right(true));
      });

      test('should delete habit from db', () async {
        when(subtaskRemoteSource.deleteSubtask(''))
            .thenAnswer((_) async => true);

        await repo.deleteSubtask('');

        verify(taskLocalSource.deleteSubTask(any));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(subtaskRemoteSource.deleteSubtask(''))
            .thenThrow(UnAuthException());

        final result = await repo.deleteSubtask('');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(subtaskRemoteSource.deleteSubtask(''))
            .thenThrow(NotFoundException());

        final result = await repo.deleteSubtask('');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(subtaskRemoteSource.deleteSubtask(''))
            .thenThrow(UnknownException());

        final result = await repo.deleteSubtask('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteTask', () {
      test('should user has an internet connection', () async {
        await repo.deleteTask('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(taskRemoteSource.deleteTask('')).thenAnswer((_) async => true);

        final result = await repo.deleteTask('');

        expect(result, Right(true));
      });

      test('should delete task from db', () async {
        when(taskRemoteSource.deleteTask('')).thenAnswer((_) async => true);

        await repo.deleteTask('');

        verify(taskLocalSource.deleteTask(any));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskRemoteSource.deleteTask('')).thenThrow(UnAuthException());

        final result = await repo.deleteTask('');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(taskRemoteSource.deleteTask('')).thenThrow(NotFoundException());

        final result = await repo.deleteTask('');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskRemoteSource.deleteTask('')).thenThrow(UnknownException());

        final result = await repo.deleteTask('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteTaskTag', () {
      test('should user has an internet connection', () async {
        await repo.deleteTaskTag('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(taskTagRemoteSource.deleteTaskTag(''))
            .thenAnswer((_) async => true);

        final result = await repo.deleteTaskTag('');

        expect(result, Right(true));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskTagRemoteSource.deleteTaskTag(''))
            .thenThrow(UnAuthException());

        final result = await repo.deleteTaskTag('');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(taskTagRemoteSource.deleteTaskTag(''))
            .thenThrow(NotFoundException());

        final result = await repo.deleteTaskTag('');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskTagRemoteSource.deleteTaskTag(''))
            .thenThrow(UnknownException());

        final result = await repo.deleteTaskTag('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editSubtask', () {
      test('should user has an internet connection', () async {
        await repo.editSubtask('', '', true, '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [HabitResult] if remote call succeed', () async {
        when(subtaskRemoteSource.editSubtask('', '', true, ''))
            .thenAnswer((_) async => subtaskResult);

        final result = await repo.editSubtask('', '', true, '');

        expect(result, Right(subtaskResult));
      });

      test('should insert new row to db', () async {
        when(subtaskRemoteSource.insertSubtask('', true, ''))
            .thenAnswer((_) async => subtaskResult);

        await repo.insertSubtask('', true, '');

        verify(taskLocalSource.insertSubTask(any));
      });

      test(
          'shuold return [SubtaskFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(subtaskRemoteSource.editSubtask('', '', true, '')).thenThrow(
            FieldsException(body: fixture('subtask_fields_error.json')));

        final result = await repo.editSubtask('', '', true, '');

        expect(result, Left(subtaskFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(subtaskRemoteSource.editSubtask('', '', true, ''))
            .thenThrow(UnAuthException());

        final result = await repo.editSubtask('', '', true, '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(subtaskRemoteSource.editSubtask('', '', true, ''))
            .thenThrow(NotFoundException());

        final result = await repo.editSubtask('', '', true, '');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(subtaskRemoteSource.editSubtask('', '', true, ''))
            .thenThrow(UnknownException());

        final result = await repo.editSubtask('', '', true, '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editTag', () {
      test('should user has an internet connection', () async {
        await repo.editTag('', '', 0);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TagResult] if remote call succeed', () async {
        when(tagRemoteSource.editTag('', '', 0))
            .thenAnswer((_) async => tagResult);

        final result = await repo.editTag('', '', 0);

        expect(result, Right(tagResult));
      });

      test('should insert new row to db', () async {
        when(tagRemoteSource.editTag('', '', 0))
            .thenAnswer((_) async => tagResult);

        await repo.editTag('', '', 0);

        verify(taskLocalSource.insertTag(any));
      });

      test(
          'shuold return [TagFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(tagRemoteSource.editTag('', '', 0))
            .thenThrow(FieldsException(body: fixture('tag_fields_error.json')));

        final result = await repo.editTag('', '', 0);

        expect(result, Left(tagFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(tagRemoteSource.editTag('', '', 0)).thenThrow(UnAuthException());

        final result = await repo.editTag('', '', 0);

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(tagRemoteSource.editTag('', '', 0)).thenThrow(NotFoundException());

        final result = await repo.editTag('', '', 0);

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(tagRemoteSource.editTag('', '', 0)).thenThrow(UnknownException());

        final result = await repo.editTag('', '', 0);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editTask', () {
      test('should user has an internet connection', () async {
        await repo.editTask('', '', '', '', null, '', '', 0, true);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TaskResult] if remote call succeed', () async {
        when(taskRemoteSource.editTask('', '', '', null, '', '', '', 0, true))
            .thenAnswer((_) async => taskResult);

        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Right(taskResult));
      });

      test('should insert new row to db', () async {
        when(taskRemoteSource.editTask('', '', '', null, '', '', '', 0, true))
            .thenAnswer((_) async => taskResult);

        await repo.editTask('', '', '', '', null, '', '', 0, true);

        verify(taskLocalSource.insertTask(any));
      });

      test(
          'shuold return [TaskFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(taskRemoteSource.editTask('', '', '', null, '', '', '', 0, true))
            .thenThrow(
                FieldsException(body: fixture('task_fields_error.json')));

        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Left(taskFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskRemoteSource.editTask('', '', '', null, '', '', '', 0, true))
            .thenThrow(UnAuthException());

        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(taskRemoteSource.editTask('', '', '', null, '', '', '', 0, true))
            .thenThrow(NotFoundException());

        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskRemoteSource.editTask('', '', '', null, '', '', '', 0, true))
            .thenThrow(UnknownException());

        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editTaskTag', () {
      test('should user has an internet connection', () async {
        await repo.editTaskTag('', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TaskTagResult] if remote call succeed', () async {
        when(taskTagRemoteSource.editTaskTag('', '', ''))
            .thenAnswer((_) async => taskTagResult);

        final result = await repo.editTaskTag('', '', '');

        expect(result, Right(taskTagResult));
      });

      test(
          'shuold return [TaskTagFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(taskTagRemoteSource.editTaskTag('', '', '')).thenThrow(
            FieldsException(body: fixture('tasktag_fields_error.json')));

        final result = await repo.editTaskTag('', '', '');

        expect(result, Left(taskTagFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskTagRemoteSource.editTaskTag('', '', ''))
            .thenThrow(UnAuthException());

        final result = await repo.editTaskTag('', '', '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(taskTagRemoteSource.editTaskTag('', '', ''))
            .thenThrow(NotFoundException());

        final result = await repo.editTaskTag('', '', '');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskTagRemoteSource.editTaskTag('', '', ''))
            .thenThrow(UnknownException());

        final result = await repo.editTaskTag('', '', '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getSubtasks', () {
      test('should user has an internet connection', () async {
        when(subtaskRemoteSource.getSubtasks('', 0))
            .thenAnswer((_) async => subtaskResponse);
        await repo.getSubtasks('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [SubtaskResponse] if remote call succeed', () async {
        when(subtaskRemoteSource.getSubtasks('', 0))
            .thenAnswer((_) async => subtaskResponse);

        final result = await repo.getSubtasks('');

        expect(result, Right(subtaskResponse));
      });

      test('should delete and insert new rows to db if offset is zero',
          () async {
        repo.subtaskOffset = 0;

        when(subtaskRemoteSource.getSubtasks('', repo.subtaskOffset))
            .thenAnswer((_) async => subtaskResponse);

        await repo.getSubtasks('');

        verify(taskLocalSource.deleteAndInsertSubTasks(any));
      });

      test('should insert new rows to db if offset is not zero', () async {
        repo.subtaskOffset = 500;

        when(subtaskRemoteSource.getSubtasks('', repo.subtaskOffset))
            .thenAnswer((_) async => subtaskResponse);

        await repo.getSubtasks('');

        verify(taskLocalSource.insertSubTasks(any));
      });

      test('should cache the offset', () async {
        when(subtaskRemoteSource.getSubtasks('', repo.subtaskOffset))
            .thenAnswer((_) async => subtaskResponse);

        await repo.getSubtasks('');

        expect(repo.subtaskOffset, 400);
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(subtaskRemoteSource.getSubtasks('', 0))
            .thenThrow(UnAuthException());
        final result = await repo.getSubtasks('');
        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(subtaskRemoteSource.getSubtasks('', 0))
            .thenThrow(UnknownException());
        final result = await repo.getSubtasks('');
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getTags', () {
      test('should user has an internet connection', () async {
        when(tagRemoteSource.getTags(0)).thenAnswer((_) async => tagResponse);
        await repo.getTags();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TagResponse] if remote call succeed', () async {
        when(tagRemoteSource.getTags(0)).thenAnswer((_) async => tagResponse);

        final result = await repo.getTags();

        expect(result, Right(tagResponse));
      });

      test('should delete and insert new rows to db if offset is zero',
          () async {
        repo.tagOffset = 0;

        when(tagRemoteSource.getTags(repo.tagOffset))
            .thenAnswer((_) async => tagResponse);

        await repo.getTags();

        verify(taskLocalSource.deleteAndInsertTags(any));
      });

      test('should insert new rows to db if offset is not zero', () async {
        repo.tagOffset = 500;

        when(tagRemoteSource.getTags(repo.tagOffset))
            .thenAnswer((_) async => tagResponse);

        await repo.getTags();

        verify(taskLocalSource.insertTags(any));
      });

      test('should cache the offset', () async {
        when(tagRemoteSource.getTags(repo.tagOffset))
            .thenAnswer((_) async => tagResponse);

        await repo.getTags();

        expect(repo.tagOffset, 400);
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(tagRemoteSource.getTags(0)).thenThrow(UnAuthException());
        final result = await repo.getTags();
        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(tagRemoteSource.getTags(0)).thenThrow(UnknownException());
        final result = await repo.getTags();
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getTasks', () {
      test('should user has an internet connection', () async {
        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenAnswer((_) async => taskResponse);
        await repo.getTasks();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TaskResponse] if remote call succeed', () async {
        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenAnswer((_) async => taskResponse);

        final result = await repo.getTasks();

        expect(result, Right(taskResponse));
      });

      test('should delete and insert new rows to db if offset is zero',
          () async {
        repo.taskOffset = 0;

        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenAnswer((_) async => taskResponse);

        await repo.getTasks();

        verify(taskLocalSource.deleteAndinsertTasks(any));
      });

      test('should insert new rows to db if offset is not zero', () async {
        repo.taskOffset = 500;

        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenAnswer((_) async => taskResponse);

        await repo.getTasks();

        verify(taskLocalSource.insertTasks(any));
      });

      test('should cache the offset', () async {
        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenAnswer((_) async => taskResponse);

        await repo.getTasks();

        expect(repo.taskOffset, 400);
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenThrow(UnAuthException());
        final result = await repo.getTasks();
        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskRemoteSource.getTasks(repo.taskOffset))
            .thenThrow(UnknownException());
        final result = await repo.getTasks();
        expect(result, Left(UnknownFailure()));
      });
    });

    group('insertSubtask', () {
      test('should user has an internet connection', () async {
        await repo.insertSubtask('', true, '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [SubtaskResult] if remote call succeed', () async {
        when(subtaskRemoteSource.insertSubtask('', true, ''))
            .thenAnswer((_) async => subtaskResult);

        final result = await repo.insertSubtask('', true, '');

        expect(result, Right(subtaskResult));
      });

      test('should insert new row to db', () async {
        when(subtaskRemoteSource.insertSubtask('', true, ''))
            .thenAnswer((_) async => subtaskResult);

        await repo.insertSubtask('', true, '');

        verify(taskLocalSource.insertSubTask(any));
      });

      test(
          'shuold return [SubtaskFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(subtaskRemoteSource.insertSubtask('', true, '')).thenThrow(
            FieldsException(body: fixture('subtask_fields_error.json')));

        final result = await repo.insertSubtask('', true, '');

        expect(result, Left(subtaskFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(subtaskRemoteSource.insertSubtask('', true, ''))
            .thenThrow(UnAuthException());

        final result = await repo.insertSubtask('', true, '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(subtaskRemoteSource.insertSubtask('', true, ''))
            .thenThrow(UnknownException());

        final result = await repo.insertSubtask('', true, '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('insertTag', () {
      test('should user has an internet connection', () async {
        await repo.insertTag('', 0);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TagResult] if remote call succeed', () async {
        when(tagRemoteSource.insertTags('', 0))
            .thenAnswer((_) async => tagResult);

        final result = await repo.insertTag('', 0);

        expect(result, Right(tagResult));
      });

      test('should insert new row to db', () async {
        when(tagRemoteSource.insertTags('', 0))
            .thenAnswer((_) async => tagResult);

        await repo.insertTag('', 0);

        verify(taskLocalSource.insertTag(any));
      });

      test(
          'shuold return [TagFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(tagRemoteSource.insertTags('', 0))
            .thenThrow(FieldsException(body: fixture('tag_fields_error.json')));

        final result = await repo.insertTag('', 0);

        expect(result, Left(tagFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(tagRemoteSource.insertTags('', 0)).thenThrow(UnAuthException());

        final result = await repo.insertTag('', 0);

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(tagRemoteSource.insertTags('', 0)).thenThrow(UnknownException());

        final result = await repo.insertTag('', 0);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('insertTask', () {
      test('should user has an internet connection', () async {
        await repo.insertTask('', '', '', null, '', '', 0, true);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TaskResult] if remote call succeed', () async {
        when(taskRemoteSource.insertTask('', '', null, '', '', '', 0, true))
            .thenAnswer((_) async => taskResult);

        final result = await repo.insertTask('', '', '', null, '', '', 0, true);

        expect(result, Right(taskResult));
      });

      test('should t new row to db', () async {
        when(taskRemoteSource.insertTask('', '', null, '', '', '', 0, true))
            .thenAnswer((_) async => taskResult);

        await repo.insertTask('', '', '', null, '', '', 0, true);

        verify(taskLocalSource.insertTask(any));
      });

      test(
          'shuold return [TaskFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(taskRemoteSource.insertTask('', '', null, '', '', '', 0, true))
            .thenThrow(
                FieldsException(body: fixture('task_fields_error.json')));

        final result = await repo.insertTask('', '', '', null, '', '', 0, true);

        expect(result, Left(taskFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskRemoteSource.insertTask('', '', null, '', '', '', 0, true))
            .thenThrow(UnAuthException());

        final result = await repo.insertTask('', '', '', null, '', '', 0, true);

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskRemoteSource.insertTask('', '', null, '', '', '', 0, true))
            .thenThrow(UnknownException());

        final result = await repo.insertTask('', '', '', null, '', '', 0, true);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('insertTaskTag', () {
      test('should user has an internet connection', () async {
        await repo.insertTaskTag('', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [TaskTagResult] if remote call succeed', () async {
        when(taskTagRemoteSource.insertTaskTag('', ''))
            .thenAnswer((_) async => taskTagResult);

        final result = await repo.insertTaskTag('', '');

        expect(result, Right(taskTagResult));
      });

      test(
          'shuold return [TaskFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(taskTagRemoteSource.insertTaskTag('', '')).thenThrow(
            FieldsException(body: fixture('tasktag_fields_error.json')));

        final result = await repo.insertTaskTag('', '');

        expect(result, Left(taskTagFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(taskTagRemoteSource.insertTaskTag('', ''))
            .thenThrow(UnAuthException());

        final result = await repo.insertTaskTag('', '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(taskTagRemoteSource.insertTaskTag('', ''))
            .thenThrow(UnknownException());

        final result = await repo.insertTaskTag('', '');

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('deleteSubtask', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteSubtask('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteSubtask('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteTask', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteTask('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteTask('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteTaskTag', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteTaskTag('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteTaskTag('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editSubtask', () {
      test('should return false if user has no internet connection', () async {
        await repo.editSubtask('', '', true, '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editSubtask('', '', true, '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editTag', () {
      test('should return false if user has no internet connection', () async {
        await repo.editTag('', '', 0);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editTag('', '', 0);
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editTask', () {
      test('should return false if user has no internet connection', () async {
        await repo.editTask('', '', '', '', null, '', '', 0, true);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editTaskTag', () {
      test('should return false if user has no internet connection', () async {
        await repo.editTaskTag('', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editTaskTag('', '', '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getSubtasks', () {
      test('should return false if user has no internet connection', () async {
        await repo.getSubtasks('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getSubtasks('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getTags', () {
      test('should return false if user has no internet connection', () async {
        await repo.getTags();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getTags();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getTasks', () {
      test('should return false if user has no internet connection', () async {
        await repo.getTasks();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getTasks();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('insertSubtask', () {
      test('should return false if user has no internet connection', () async {
        await repo.insertSubtask('', true, '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.insertSubtask('', true, '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('insertTask', () {
      test('should return false if user has no internet connection', () async {
        await repo.editTask('', '', '', '', null, '', '', 0, true);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result =
            await repo.editTask('', '', '', '', null, '', '', 0, true);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('insertTag', () {
      test('should return false if user has no internet connection', () async {
        await repo.insertTag('', 0);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.insertTag('', 0);
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('insertTaskTag', () {
      test('should return false if user has no internet connection', () async {
        await repo.insertTaskTag('', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.insertTaskTag('', '');
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
