import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/data/data_sources/auth/auth_remote_source.dart';
import 'package:diana/data/remote_models/auth/login_info.dart';
import 'package:diana/data/remote_models/auth/refresh_info.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  AuthRemoteSourceImpl remoteSource;

  final user = User.fromJson(json.decode(fixture('user.json')));
  final loginInfo = LoginInfo.fromJson(json.decode(fixture('login.json')));
  final refreshInfo =
      RefreshInfo.fromJson(json.decode(fixture('refresh.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = AuthRemoteSourceImpl(client: client);
  });

  group('registerUser', () {
    test('should return [User] if response code is 201', () async {
      when(client.post(
        '$baseUrl/accounts/registration/',
        body: {
          "first_name": "string",
          "last_name": "string",
          "username": "string",
          "email": "user@example.com",
          "birthdate": "2021-01-13",
          "password": ""
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('registration.json'), 201));

      final result = await remoteSource.registerUser(user.firstName,
          user.lastName, user.username, user.email, user.birthdate, '');

      expect(result, user);
    });

    test('should throw [FieldsException] if response code is 400', () async {
      when(client.post('$baseUrl/accounts/registration/', body: {
        "first_name": "string",
        "last_name": "string",
        "username": "string",
        "email": "user@example.com",
        "birthdate": "2021-01-13",
        "password": ""
      })).thenAnswer(
          (_) async => http.Response(fixture('user_fields_error.json'), 400));

      final result = remoteSource.registerUser;

      expect(
        result(user.firstName, user.lastName, user.username, user.email,
            user.birthdate, ''),
        throwsA(isA<FieldsException>()),
      );
    });

    test('should throw [UnknownException] if response code is not 201 or 400',
        () async {
      when(client.post('$baseUrl/accounts/registration/', body: {
        "first_name": "string",
        "last_name": "string",
        "username": "string",
        "email": "user@example.com",
        "birthdate": "2021-01-13",
        "password": ""
      })).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.registerUser;

      expect(
        result(user.firstName, user.lastName, user.username, user.email,
            user.birthdate, ''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('loginUser', () {
    test('should return [loginInfo] if response code is 200', () async {
      when(client.post(
        '$baseUrl/accounts/login/',
        body: {
          "username": "string",
          "password": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('login.json'), 200));

      final result = await remoteSource.loginUser(user.username, '');

      expect(result, loginInfo);
    });

    test('should throw [NonFieldsException] if response code is 400', () async {
      when(client.post(
        '$baseUrl/accounts/login/',
        body: {
          "username": "string",
          "password": "",
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('non_field_errors.json'), 400));

      final result = remoteSource.loginUser;

      expect(
        result(user.username, ''),
        throwsA(isA<NonFieldsException>()),
      );
    });

    test('should throw [UnknownException] if response code is not 200 or 400',
        () async {
      when(client.post(
        '$baseUrl/accounts/login/',
        body: {
          "username": "string",
          "password": "",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.loginUser;

      expect(
        result(user.username, ''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('logoutUser', () {
    test('should return [true] if response code is 200', () async {
      when(client.post(
        '$baseUrl/accounts/logout/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 200));

      final result = await remoteSource.logoutUser();

      expect(result, true);
    });

    test('should throw [UnknownException] if response code is not 200',
        () async {
      when(client.post(
        '$baseUrl/accounts/logout/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.logoutUser;

      expect(
        result(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('changePass', () {
    test('should return [true] if response code is 200', () async {
      when(client.post(
        '$baseUrl/accounts/password/change/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "new_password1": '',
          "new_password2": '',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 200));

      final result = await remoteSource.changePass('', '');

      expect(result, true);
    });

    test('should throw [UnAuthException] if response code is 401', () async {
      when(client.post(
        '$baseUrl/accounts/password/change/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "new_password1": '',
          "new_password2": '',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.changePass;

      expect(
        result('', ''),
        throwsA(isA<UnAuthException>()),
      );
    });

    test('should throw [FieldsException] if response code is 400', () async {
      when(client.post(
        '$baseUrl/accounts/password/change/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "new_password1": '',
          "new_password2": '',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.changePass;

      expect(
        result('', ''),
        throwsA(isA<FieldsException>()),
      );
    });

    test('should throw [UnknownException] if response code is none of above',
        () async {
      when(client.post(
        '$baseUrl/accounts/password/change/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "new_password1": '',
          "new_password2": '',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.changePass;

      expect(
        result('', ''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('editUser', () {
    test('should return [User] if response code is 200', () async {
      when(client.patch(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "first_name": "string",
          "last_name": "string",
          "username": "string",
          "email": "user@example.com",
          "birthdate": "2021-01-13",
          "password": ""
        },
      )).thenAnswer((_) async => http.Response(fixture('user.json'), 200));

      final result = await remoteSource.editUser(user.firstName, user.lastName,
          user.username, user.email, user.birthdate, '');

      expect(result, user);
    });

    test('should throw [UnAuthException] if response code is 401', () async {
      when(client.patch(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "first_name": "string",
          "last_name": "string",
          "username": "string",
          "email": "user@example.com",
          "birthdate": "2021-01-13",
          "password": ""
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editUser;

      expect(
        result(user.firstName, user.lastName, user.username, user.email,
            user.birthdate, ''),
        throwsA(isA<UnAuthException>()),
      );
    });

    test('should throw [FieldsException] if response code is 400', () async {
      when(client.patch(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "first_name": "string",
          "last_name": "string",
          "username": "string",
          "email": "user@example.com",
          "birthdate": "2021-01-13",
          "password": ""
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editUser;

      expect(
        result(user.firstName, user.lastName, user.username, user.email,
            user.birthdate, ''),
        throwsA(isA<FieldsException>()),
      );
    });

    test('should throw [UnknownException] if response code is none of above',
        () async {
      when(client.patch(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
        body: {
          "first_name": "string",
          "last_name": "string",
          "username": "string",
          "email": "user@example.com",
          "birthdate": "2021-01-13",
          "password": ""
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editUser;

      expect(
        result(user.firstName, user.lastName, user.username, user.email,
            user.birthdate, ''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('getUser', () {
    test('should return [User] if response code is 200', () async {
      when(client.get(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('user.json'), 200));

      final result = await remoteSource.getUser();

      expect(result, user);
    });

    test('should throw [UnAuthException] if response code is 401', () async {
      when(client.get(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getUser;

      expect(
        result(),
        throwsA(isA<UnAuthException>()),
      );
    });

    test('should throw [UnknownException] if response code is none of above',
        () async {
      when(client.get(
        '$baseUrl/accounts/user/',
        headers: {
          'Authorization': 'Bearer $kToken',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getUser;

      expect(
        result(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('resetPass', () {
    test('should return [true] if response code is 200', () async {
      when(client.post(
        '$baseUrl/accounts/password/reset/',
        body: {'email': ''},
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 200));

      final result = await remoteSource.resetPass('');

      expect(result, true);
    });

    test('should throw [UnknownException] if response code is none of above',
        () async {
      when(client.post(
        '$baseUrl/accounts/password/reset/',
        body: {'email': ''},
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.resetPass;

      expect(
        result(''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('requestToken', () {
    test('should return [RefreshInfo] if response code is 200', () async {
      when(client.post(
        '$baseUrl/accounts/token/refresh/',
        body: {
          "refresh": "string",
        },
      )).thenAnswer((_) async => http.Response(fixture('refresh.json'), 200));

      final result = await remoteSource.requestToken('string');

      expect(result, refreshInfo);
    });

    test('should throw [UnAuthException] if response code is 401', () async {
      when(client.post(
        '$baseUrl/accounts/token/refresh/',
        body: {
          "refresh": "string",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.requestToken;

      expect(
        result('string'),
        throwsA(isA<UnAuthException>()),
      );
    });

    test('should throw [UnknownException] if response code is none of above',
        () async {
      when(client.post(
        '$baseUrl/accounts/token/refresh/',
        body: {
          "refresh": "string",
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.requestToken;

      expect(
        result('string'),
        throwsA(isA<UnknownException>()),
      );
    });
  });
}
