import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/data/data_sources/habitlog/habitlog_remote_source.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  HabitlogRemoteSourceImpl remoteSource;
  final habitlogResponse =
      HabitlogResponse.fromJson(json.decode(fixture('habitlog.json')));
  final habitlogResult =
      HabitlogResult.fromJson(json.decode(fixture('habitlog_result.json')));
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = HabitlogRemoteSourceImpl(client: client);
  });

  group('getHabitlogs', () {
    test('should return [HabitlogResponse] if response code is 200', () async {
      when(client.get(
        '$baseUrl/habitlog/?limit=10&offset=$offset&habit=null/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('habitlog.json'), 200));

      final result = await remoteSource.getHabitlogs(offset, null);

      expect(result, habitlogResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.get(
        '$baseUrl/habitlog/?limit=10&offset=$offset&habit=null/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getHabitlogs;

      expect(result(offset, null), throwsA(isA<UnAuthException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.get(
        '$baseUrl/habitlog/?limit=10&offset=$offset&habit=null/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getHabitlogs;

      expect(result(offset, null), throwsA(isA<UnknownException>()));
    });
  });

  group('insertHabitlog', () {
    test('should return [HabitResult] if response code is 201', () async {
      when(client.post(
        '$baseUrl/habitlog/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "habit": "",
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('habitlog_result.json'), 201));

      final result = await remoteSource.insertHabitlog('');

      expect(result, habitlogResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.post(
        '$baseUrl/habitlog/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "habit": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.insertHabitlog;

      expect(result(''), throwsA(isA<UnAuthException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.post(
        '$baseUrl/habitlog/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "habit": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.insertHabitlog;

      expect(result(''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.post(
        '$baseUrl/habitlog/',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "habit": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.insertHabitlog;

      expect(result(''), throwsA(isA<UnknownException>()));
    });
  });
}
