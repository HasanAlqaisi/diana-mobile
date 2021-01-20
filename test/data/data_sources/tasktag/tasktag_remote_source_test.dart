import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_remote_source.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  TaskTagRemoteSourceImpl remoteSource;
  final tasktagResponse =
      TaskTagResponse.fromJson(json.decode(fixture('tasktag.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = TaskTagRemoteSourceImpl(client: client);
  });

  group('insertTaskTag', () {
    test('should return [TaskTagResponse] if response code is 201', () async {
      when(client.post(
        '$baseUrl/tasktag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('tasktag.json'), 201));

      final result = await remoteSource.insertTaskTag('', '');

      expect(result, tasktagResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.post(
        '$baseUrl/tasktag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.insertTaskTag;

      expect(result('', ''), throwsA(isA<UnAuthException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.post(
        '$baseUrl/tasktag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.insertTaskTag;

      expect(result('', ''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.post(
        '$baseUrl/tasktag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.insertTaskTag;

      expect(result('', ''), throwsA(isA<UnknownException>()));
    });
  });

  group('editTaskTag', () {
    test('should return [TaskTagResponse] if response code is 200', () async {
      when(client.put(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('tasktag.json'), 200));

      final result = await remoteSource.editTaskTag('', '', '');

      expect(result, tasktagResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.put(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editTaskTag;

      expect(result('', '', ''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.put(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editTaskTag;

      expect(result('', '', ''), throwsA(isA<NotFoundException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.put(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editTaskTag;

      expect(result('', '', ''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.put(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "task": "",
          "tag": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editTaskTag;

      expect(result('', '', ''), throwsA(isA<UnknownException>()));
    });
  });

  group('deleteTaskTag', () {
    test('should return [true] if response code is 204', () async {
      when(client.delete(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 204));

      final result = await remoteSource.deleteTaskTag('');

      expect(result, true);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.delete(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteTaskTag;

      expect(result(''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.delete(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteTaskTag;

      expect(result(''), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.delete(
        '$baseUrl/tasktag//',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteTaskTag;

      expect(result(''), throwsA(isA<UnknownException>()));
    });
  });
}
