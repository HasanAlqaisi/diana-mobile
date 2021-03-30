import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/data/data_sources/task/task_remote_source.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  TaskRemoteSourceImpl remoteSource;
  final taskResponse = TaskResponse.fromJson(json.decode(fixture('task.json')));
  final taskResult =
      TaskResult.fromJson(json.decode(fixture('task_result.json')));
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = TaskRemoteSourceImpl(client: client);
  });

  group('getTasks', () {
    test('should return [TaskResponse] if response code is 200', () async {
      when(client.get(
        '$baseUrl/task/?limit=100&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('task.json'), 200));

      final result = await remoteSource.getTasks(offset);

      expect(result, taskResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.get(
        '$baseUrl/task/?limit=100&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getTasks;

      expect(result(offset), throwsA(isA<UnAuthException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.get(
        '$baseUrl/task/?limit=100&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getTasks;

      expect(result(offset), throwsA(isA<UnknownException>()));
    });
  });

  group('insertTask', () {
    test('should return [TaskResult] if response code is 201', () async {
      when(client.post(
        '$baseUrl/task/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('task_result.json'), 201));

      final result =
          await remoteSource.insertTask('', '', null, '', '', '', 0, false);

      expect(result, taskResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.post(
        '$baseUrl/task/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.insertTask;

      expect(result('', '', null, '', '', '', 0, false),
          throwsA(isA<UnAuthException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.post(
        '$baseUrl/task/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.insertTask;

      expect(result('', '', null, '', '', '', 0, false),
          throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.post(
        '$baseUrl/task/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.insertTask;

      expect(result('', '', null, '', '', '', 0, false),
          throwsA(isA<UnknownException>()));
    });
  });

  group('editTask', () {
    test('should return [TaskResult] if response code is 200', () async {
      when(client.put(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('task_result.json'), 200));

      final result =
          await remoteSource.editTask('', '', '', null, '', '', '', 0, false);

      expect(result, taskResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.put(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editTask;

      expect(result('', '', '', null, '', '', '', 0, false),
          throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.put(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editTask;

      expect(result('', '', '', null, '', '', '', 0, false),
          throwsA(isA<NotFoundException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.put(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editTask;

      expect(result('', '', '', null, '', '', '', 0, false),
          throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.put(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "note": "",
          "with_tags": null,
          "date": "",
          "reminder": "",
          "deadline": "",
          "priority": 0,
          "done": false
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editTask;

      expect(result('', '', '', null, '', '', '', 0, false),
          throwsA(isA<UnknownException>()));
    });
  });

  group('deleteTask', () {
    test('should return [true] if response code is 204', () async {
      when(client.delete(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 204));

      final result = await remoteSource.deleteTask('');

      expect(result, true);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.delete(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteTask;

      expect(result(''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.delete(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteTask;

      expect(result(''), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.delete(
        '$baseUrl/task//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteTask;

      expect(result(''), throwsA(isA<UnknownException>()));
    });
  });
}
