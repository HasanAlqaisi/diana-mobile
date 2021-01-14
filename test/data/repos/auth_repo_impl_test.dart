import 'dart:convert';

import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/auth/auth_remote_source.dart';
import 'package:diana/data/remote_models/auth/login_info.dart';
import 'package:diana/data/remote_models/auth/refresh_info.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:diana/data/repos/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';

import '../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements AuthRemoteSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  AuthRepoImpl repo;

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    repo = AuthRepoImpl(netWorkInfo: netWorkInfo, remoteSource: remoteSource);
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('changePass', () {
      test('should user has an internet connection', () async {
        await repo.changePass('', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(remoteSource.changePass('', '')).thenAnswer((_) async => true);

        final result = await repo.changePass('', '');

        expect(result, Right(true));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(remoteSource.changePass('', '')).thenThrow(UnAuthException());
        final result = await repo.changePass('', '');
        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [ChangePassFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final changePassFailure = ChangePassFieldsFailure(
          pass1: ['This field is required.'],
        );

        when(remoteSource.changePass('', '')).thenThrow(
            FieldsException(body: fixture('changepass_fields_error.json')));

        final result = await repo.changePass('', '');

        expect(result, Left(changePassFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.changePass('', '')).thenThrow(UnknownException());
        final result = await repo.changePass('', '');
        expect(result, Left(UnknownFailure()));
      });
    });

    group('editUser', () {
      final user = User.fromJson(json.decode(fixture('user.json')));

      test('should user has an internet connection', () async {
        await repo.editUser('', '', '', '', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(remoteSource.editUser('', '', '', '', '', ''))
            .thenAnswer((_) async => user);

        final result = await repo.editUser('', '', '', '', '', '');

        expect(result, Right(user));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(remoteSource.editUser('', '', '', '', '', ''))
            .thenThrow(UnAuthException());

        final result = await repo.editUser('', '', '', '', '', '');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UserFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final userFieldsFailure = UserFieldsFailure(
          username: ['user with this username already exists.'],
          email: ['user with this username already exists.'],
        );

        when(remoteSource.editUser('', '', '', '', '', '')).thenThrow(
            FieldsException(body: fixture('user_fields_error.json')));

        final result = await repo.editUser('', '', '', '', '', '');

        expect(result, Left(userFieldsFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.editUser('', '', '', '', '', ''))
            .thenThrow(UnknownException());

        final result = await repo.editUser('', '', '', '', '', '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getUser', () {
      final user = User.fromJson(json.decode(fixture('user.json')));

      test('should user has an internet connection', () async {
        await repo.getUser();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [user] if remote call succeed', () async {
        when(remoteSource.getUser()).thenAnswer((_) async => user);

        final result = await repo.getUser();

        expect(result, Right(user));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(remoteSource.getUser()).thenThrow(UnAuthException());

        final result = await repo.getUser();

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getUser()).thenThrow(UnknownException());

        final result = await repo.getUser();

        expect(result, Left(UnknownFailure()));
      });
    });

    group('loginUser', () {
      final loginInfo = LoginInfo.fromJson(json.decode(fixture('login.json')));

      test('should user has an internet connection', () async {
        await repo.loginUser('', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [LoginInfo] if remote call succeed', () async {
        when(remoteSource.loginUser('', '')).thenAnswer((_) async => loginInfo);

        final result = await repo.loginUser('', '');

        expect(result, Right(loginInfo));
      });

      test(
          'should return [NonFieldsFailure] if the remote call throw [NonFieldsException]',
          () async {
        final nonFieldsFailure = NonFieldsFailure(
          errors: ['Unable to log in with provided credentials.'],
        );

        when(remoteSource.loginUser('', '')).thenThrow(
            NonFieldsException(message: fixture('non_field_errors.json')));

        final result = await repo.loginUser('', '');

        expect(result, Left(nonFieldsFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.loginUser('', '')).thenThrow(UnknownException());

        final result = await repo.loginUser('', '');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('logoutUser', () {
      test('should user has an internet connection', () async {
        await repo.logoutUser();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call succeed', () async {
        when(remoteSource.logoutUser()).thenAnswer((_) async => true);

        final result = await repo.logoutUser();

        expect(result, Right(true));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.logoutUser()).thenThrow(UnknownException());

        final result = await repo.logoutUser();

        expect(result, Left(UnknownFailure()));
      });
    });

    group('requestToken', () {
      final refreshInfo =
          RefreshInfo.fromJson(json.decode(fixture('refresh.json')));

      test('should user has an internet connection', () async {
        await repo.requestToken('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [refreshInfo] if remote call succeed', () async {
        when(remoteSource.requestToken(''))
            .thenAnswer((_) async => refreshInfo);

        final result = await repo.requestToken('');

        expect(result, Right(refreshInfo));
      });

      test(
          'shuold return [UnAuthFailure] if remote call throws [UnAuthException]',
          () async {
        when(remoteSource.requestToken('')).thenThrow(UnAuthException());

        final result = await repo.requestToken('');

        expect(result, Left(UnAuthFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.requestToken('')).thenThrow(UnknownException());

        final result = await repo.requestToken('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('resetPass', () {
      test('should user has an internet connection', () async {
        await repo.resetPass('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [refreshInfo] if remote call succeed', () async {
        when(remoteSource.resetPass('')).thenAnswer((_) async => true);

        final result = await repo.resetPass('');

        expect(result, Right(true));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.resetPass('')).thenThrow(UnknownException());

        final result = await repo.resetPass('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('registerUser', () {
      final user = User.fromJson(json.decode(fixture('user.json')));

      test('should user has an internet connection', () async {
        await repo.registerUser('', '', '', '', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [user] if remote call succeed', () async {
        when(remoteSource.registerUser('', '', '', '', '', ''))
            .thenAnswer((_) async => user);

        final result = await repo.registerUser('', '', '', '', '', '');

        expect(result, Right(user));
      });

      test(
          'shuold return [UserFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final userFieldsFailure = UserFieldsFailure(
          username: ['user with this username already exists.'],
          email: ['user with this username already exists.'],
        );

        when(remoteSource.registerUser('', '', '', '', '', '')).thenThrow(
            FieldsException(body: fixture('user_fields_error.json')));

        final result = await repo.registerUser('', '', '', '', '', '');

        expect(result, Left(userFieldsFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.registerUser('', '', '', '', '', ''))
            .thenThrow(UnknownException());

        final result = await repo.registerUser('', '', '', '', '', '');

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('changePass', () {
      test('should return false if user has no internet connection', () async {
        await repo.changePass('', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.changePass('', '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editUser', () {
      test('should return false if user has no internet connection', () async {
        await repo.editUser('', '', '', '', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editUser('', '', '', '', '', '');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getUser', () {
      test('should return false if user has no internet connection', () async {
        await repo.getUser();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getUser();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('logoutUser', () {
      test('should return false if user has no internet connection', () async {
        await repo.logoutUser();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.logoutUser();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('requestToken', () {
      test('should return false if user has no internet connection', () async {
        await repo.requestToken('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.requestToken('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('resetPass', () {
      test('should return false if user has no internet connection', () async {
        await repo.resetPass('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.resetPass('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('registerUser', () {
      test('should return false if user has no internet connection', () async {
        await repo.registerUser('', '', '', '', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });
      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.registerUser('', '', '', '', '', '');
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
