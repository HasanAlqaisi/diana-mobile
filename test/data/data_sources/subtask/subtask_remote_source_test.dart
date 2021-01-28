import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/data_sources/subtask/subtask_remote_source.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  SubtaskRemoteSourceImpl remoteSource;
  final subtaskResponse =
      SubtaskResponse.fromJson(json.decode(fixture('subtask.json')));
  final subtaskResult =
      SubtaskResult.fromJson(json.decode(fixture('subtask_result.json')));
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = SubtaskRemoteSourceImpl(client: client);
  });

  group('getSubtasks', () {
    test('should return [SubtaskResponse] if response code is 200', () async {
      when(client.get(
        '$baseUrl/subtask//?limit=10&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('subtask.json'), 200));

      final result = await remoteSource.getSubtasks('', offset);

      expect(result, subtaskResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.get(
        '$baseUrl/subtask//?limit=10&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getSubtasks;

      expect(result('', offset), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.get(
        '$baseUrl/subtask//?limit=10&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.getSubtasks;

      expect(result('', offset), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.get(
        '$baseUrl/subtask//?limit=10&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getSubtasks;

      expect(result('', offset), throwsA(isA<UnknownException>()));
    });
  });

  group('insertSubtask', () {
    test('should return [SubtaskResult] if response code is 201', () async {
      when(client.post(
        '$baseUrl/subtask/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('subtask_result.json'), 201));

      final result = await remoteSource.insertSubtask('', true, '');

      expect(result, subtaskResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.post(
        '$baseUrl/subtask/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.insertSubtask;

      expect(result('', true, ''), throwsA(isA<UnAuthException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.post(
        '$baseUrl/subtask/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.insertSubtask;

      expect(result('', true, ''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.post(
        '$baseUrl/subtask/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.insertSubtask;

      expect(result('', true, ''), throwsA(isA<UnknownException>()));
    });
  });

  group('editSubtask', () {
    test('should return [SubtaskResult] if response code is 200', () async {
      when(client.put(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('subtask_result.json'), 200));

      final result = await remoteSource.editSubtask('', '', true, '');

      expect(result, subtaskResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.put(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editSubtask;

      expect(result('', '', true, ''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.put(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editSubtask;

      expect(result('', '', true, ''), throwsA(isA<NotFoundException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.put(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editSubtask;

      expect(result('', '', true, ''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.put(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "done": true,
          "task": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editSubtask;

      expect(result('', '', true, ''), throwsA(isA<UnknownException>()));
    });
  });

  group('deleteSubtask', () {
    test('should return [true] if response code is 204', () async {
      when(client.delete(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 204));

      final result = await remoteSource.deleteSubtask('');

      expect(result, true);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.delete(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteSubtask;

      expect(result(''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.delete(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteSubtask;

      expect(result(''), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.delete(
        '$baseUrl/subtask//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteSubtask;

      expect(result(''), throwsA(isA<UnknownException>()));
    });
  });
}
