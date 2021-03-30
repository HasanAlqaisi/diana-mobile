import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/data/data_sources/habit/habit_remote_source.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  HabitRemoteSourceImpl remoteSource;
  final habitResponse =
      HabitResponse.fromJson(json.decode(fixture('habit.json')));
  final habitResult =
      HabitResult.fromJson(json.decode(fixture('habit_result.json')));
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = HabitRemoteSourceImpl(client: client);
  });

  group('getHabits', () {
    test('should return [HabitResponse] if response code is 200', () async {
      when(client.get(
        '$baseUrl/habit/?limit=100&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('habit.json'), 200));

      final result = await remoteSource.getHabits(offset);

      expect(result, habitResponse);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.get(
        '$baseUrl/habit/?limit=100&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getHabits;

      expect(result(offset), throwsA(isA<UnAuthException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.get(
        '$baseUrl/habit/?limit=100&offset=$offset',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getHabits;

      expect(result(offset), throwsA(isA<UnknownException>()));
    });
  });

  group('insertHabit', () {
    test('should return [HabitResult] if response code is 201', () async {
      when(client.post(
        '$baseUrl/habit/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('habit_result.json'), 201));

      final result = await remoteSource.insertHabit('', [], '');

      expect(result, habitResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.post(
        '$baseUrl/habit/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.insertHabit;

      expect(result('', [], ''), throwsA(isA<UnAuthException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.post(
        '$baseUrl/habit/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.insertHabit;

      expect(result('', [], ''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.post(
        '$baseUrl/habit/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.insertHabit;

      expect(result('', [], ''), throwsA(isA<UnknownException>()));
    });
  });

  group('editHabit', () {
    test('should return [HabitResult] if response code is 200', () async {
      when(client.put(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('habit_result.json'), 200));

      final result = await remoteSource.editHabit('', '', [], '');

      expect(result, habitResult);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.put(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editHabit;

      expect(result('', '', [], ''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.put(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editHabit;

      expect(result('', '', [], ''), throwsA(isA<NotFoundException>()));
    });

    test('should throw FieldsException if response code is 400', () {
      when(client.put(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editHabit;

      expect(result('', '', [], ''), throwsA(isA<FieldsException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.put(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "name": "",
          "days": [],
          "time": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editHabit;

      expect(result('', '', [], ''), throwsA(isA<UnknownException>()));
    });
  });

  group('deleteHabit', () {
    test('should return [true] if response code is 204', () async {
      when(client.delete(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 204));

      final result = await remoteSource.deleteHabit('');

      expect(result, true);
    });

    test('should throw UnAuthException if response code is 401', () {
      when(client.delete(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteHabit;

      expect(result(''), throwsA(isA<UnAuthException>()));
    });

    test('should throw NotFoundException if response code is 404', () {
      when(client.delete(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteHabit;

      expect(result(''), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException if response code is not listed above',
        () {
      when(client.delete(
        '$baseUrl/habit//',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteHabit;

      expect(result(''), throwsA(isA<UnknownException>()));
    });
  });
}
