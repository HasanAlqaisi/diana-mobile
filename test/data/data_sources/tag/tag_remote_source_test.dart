import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/data/data_sources/tag/tag_remote_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  TagRemoteSourceImpl remoteSource;
  final tagResponse = TagResponse.fromJson(json.decode(fixture('tag.json')));
  final tagResult = TagResult.fromJson(json.decode(fixture('tag_result.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = TagRemoteSourceImpl(client: client);
  });

  group('getTags', () {
    test('should return [TagResponse] if response code is 200', () async {
      when(client.get(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('tag.json'), 200));

      final result = await remoteSource.getTags();

      expect(result, tagResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.get(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getTags;

      expect(result(), throwsA(isA<UnAuthException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.get(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getTags;

      expect(result(), throwsA(isA<UnknownException>()));
    });
  });

  group('insertTag', () {
    test('should return [TagResult] if response code is 201', () async {
      when(client.post(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('tag_result.json'), 201));

      final result = await remoteSource.insertTags('string', 0);

      expect(result, tagResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.post(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.insertTags;

      expect(result('string', 0), throwsA(isA<UnAuthException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.post(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.insertTags;

      expect(result('string', 0), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.post(
        '$baseUrl/tag/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.insertTags;

      expect(result('string', 0), throwsA(isA<UnknownException>()));
    });
  });

  group('editTag', () {
    test('should return [TagResult] if response code is 200', () async {
      when(client.put(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('tag_result.json'), 200));

      final result = await remoteSource.editTag(
          '3fa85f64-5717-4562-b3fc-2c963f66afa6', 'string', 0);

      expect(result, tagResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.put(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6', 'string', 0),
          throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.put(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6', 'string', 0),
          throwsA(isA<NotFoundException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.put(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6', 'string', 0),
          throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.put(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": "string",
          "color": 0,
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6', 'string', 0),
          throwsA(isA<UnknownException>()));
    });
  });

  group('deleteTag', () {
    test('should return [true] if response code is 204', () async {
      when(client.delete(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 204));

      final result =
          await remoteSource.deleteTag('3fa85f64-5717-4562-b3fc-2c963f66afa6');

      expect(result, true);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.delete(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
          throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.delete(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
          throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.delete(
        '$baseUrl/tag/3fa85f64-5717-4562-b3fc-2c963f66afa6/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteTag;

      expect(result('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
          throwsA(isA<UnknownException>()));
    });
  });
}
