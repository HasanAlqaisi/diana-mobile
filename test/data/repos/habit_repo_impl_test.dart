import 'dart:convert';

import 'package:diana/core/errors/days_errors.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/habit/habit_remote_source.dart';
import 'package:diana/data/data_sources/habitlog/habitlog_remote_source.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:diana/data/repos/habit_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';

import '../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockHabitRemoteSource extends Mock implements HabitRemoteSource {}

class MockHabitlogRemoteSource extends Mock implements HabitlogRemoteSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockHabitRemoteSource habitRemoteSource;
  MockHabitlogRemoteSource habitlogRemoteSource;
  HabitRepoImpl repo;

  final habitResponse =
      HabitResponse.fromJson(json.decode(fixture('habit.json')));
  final habitResult =
      HabitResult.fromJson(json.decode(fixture('habit_result.json')));

  final habitlogResponse =
      HabitlogResponse.fromJson(json.decode(fixture('habitlog.json')));
  final habitlogResult =
      HabitlogResult.fromJson(json.decode(fixture('habitlog_result.json')));

  final habitFieldsFailure = HabitFieldsFailure(
    days: DaysError.fromJson(json.decode(fixture('habit_fields_error.json'))['days']),
  );

  final habitlogFieldsFailure = HabitlogFieldsFailure(
    habitlogId: ['habit id not valid!'],
  );

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    habitRemoteSource = MockHabitRemoteSource();
    habitlogRemoteSource = MockHabitlogRemoteSource();
    repo = HabitRepoImpl(
      netWorkInfo: netWorkInfo,
      habitRemoteSource: habitRemoteSource,
      habitlogRemoteSource: habitlogRemoteSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getHabits', () {
      test('should user has an internet connection', () async {
        await repo.getHabits(0);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [HabitResponse] if remote call succeed', () async {
        when(habitRemoteSource.getHabits(0))
            .thenAnswer((_) async => habitResponse);

        final result = await repo.getHabits(0);

        expect(result, Right(habitResponse));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(habitRemoteSource.getHabits(0)).thenThrow(UnAuthException());
        final result = await repo.getHabits(0);
        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(habitRemoteSource.getHabits(0)).thenThrow(UnknownException());
        final result = await repo.getHabits(0);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('insertHabit', () {
      test('should user has an internet connection', () async {
        await repo.insertHabit('', [], '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [HabitResult] if remote call succeed', () async {
        when(habitRemoteSource.insertHabit('', [], ''))
            .thenAnswer((_) async => habitResult);

        final result = await repo.insertHabit('', [], '');

        expect(result, Right(habitResult));
      });

      test(
          'shuold return [HabitFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(habitRemoteSource.insertHabit('', [], '')).thenThrow(
            FieldsException(body: fixture('habit_fields_error.json')));

        final result = await repo.insertHabit('', [], '');
        
        expect(result, Left(habitFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(habitRemoteSource.insertHabit('', [], ''))
            .thenThrow(UnAuthException());

        final result = await repo.insertHabit('', [], '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(habitRemoteSource.insertHabit('', [], ''))
            .thenThrow(UnknownException());

        final result = await repo.insertHabit('', [], '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editHabit', () {
      test('should user has an internet connection', () async {
        await repo.editHabit('', '', [], '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [HabitResult] if remote call succeed', () async {
        when(habitRemoteSource.editHabit('', '', [], ''))
            .thenAnswer((_) async => habitResult);

        final result = await repo.editHabit('', '', [], '');

        expect(result, Right(habitResult));
      });

      test(
          'shuold return [HabitFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(habitRemoteSource.editHabit('', '', [], '')).thenThrow(
            FieldsException(body: fixture('habit_fields_error.json')));

        final result = await repo.editHabit('', '', [], '');

        expect(result, Left(habitFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(habitRemoteSource.editHabit('', '', [], ''))
            .thenThrow(UnAuthException());

        final result = await repo.editHabit('', '', [], '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(habitRemoteSource.editHabit('', '', [], ''))
            .thenThrow(NotFoundException());

        final result = await repo.editHabit('', '', [], '');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(habitRemoteSource.editHabit('', '', [], ''))
            .thenThrow(UnknownException());

        final result = await repo.editHabit('', '', [], '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteHabit', () {
      test('should user has an internet connection', () async {
        await repo.deleteHabit('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(habitRemoteSource.deleteHabit('')).thenAnswer((_) async => true);

        final result = await repo.deleteHabit('');

        expect(result, Right(true));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(habitRemoteSource.deleteHabit('')).thenThrow(UnAuthException());

        final result = await repo.deleteHabit('');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [NotFoundFailure] if remote call throws [NotFoundException]',
          () async {
        when(habitRemoteSource.deleteHabit('')).thenThrow(NotFoundException());

        final result = await repo.deleteHabit('');

        expect(result, Left(NotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(habitRemoteSource.deleteHabit('')).thenThrow(UnknownException());

        final result = await repo.deleteHabit('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getHabitlogs', () {
      test('should user has an internet connection', () async {
        await repo.getHabitlogs(0, '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [HabitlogResponse] if remote call succeed', () async {
        when(habitlogRemoteSource.getHabitlogs(0, ''))
            .thenAnswer((_) async => habitlogResponse);

        final result = await repo.getHabitlogs(0, '');

        expect(result, Right(habitlogResponse));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(habitlogRemoteSource.getHabitlogs(0, ''))
            .thenThrow(UnAuthException());

        final result = await repo.getHabitlogs(0, '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(habitlogRemoteSource.getHabitlogs(0, ''))
            .thenThrow(UnknownException());

        final result = await repo.getHabitlogs(0, '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('insertHabitlog', () {
      test('should user has an internet connection', () async {
        await repo.insertHabitlog('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [HabitlogResult] if remote call succeed', () async {
        when(habitlogRemoteSource.insertHabitlog(''))
            .thenAnswer((_) async => habitlogResult);

        final result = await repo.insertHabitlog('');

        expect(result, Right(habitlogResult));
      });

      test(
          'shuold return [HabitlogFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(habitlogRemoteSource.insertHabitlog('')).thenThrow(
            FieldsException(body: fixture('habitlog_fields_error.json')));

        final result = await repo.insertHabitlog('');

        expect(result, Left(habitlogFieldsFailure));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(habitlogRemoteSource.insertHabitlog(''))
            .thenThrow(UnAuthException());

        final result = await repo.insertHabitlog('');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(habitlogRemoteSource.insertHabitlog(''))
            .thenThrow(UnknownException());

        final result = await repo.insertHabitlog('');

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('getHabits', () {
      test('should return false if user has no internet connection', () async {
        await repo.getHabits(0);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getHabits(0);
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('insertHabit', () {
      test('should return false if user has no internet connection', () async {
        await repo.insertHabit('', [], '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.insertHabit('', [], '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editHabit', () {
      test('should return false if user has no internet connection', () async {
        await repo.editHabit('', '', [], '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editHabit('', '', [], '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteHabit', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteHabit('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteHabit('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getHabitlogs', () {
      test('should return false if user has no internet connection', () async {
        await repo.getHabitlogs(0, '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getHabitlogs(0, '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('insertHabitlogs', () {
      test('should return false if user has no internet connection', () async {
        await repo.insertHabitlog('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.insertHabitlog('');
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
