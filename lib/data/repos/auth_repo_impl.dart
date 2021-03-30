import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diana/core/constants/_constants.dart';

import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/auth/auth_local_source.dart';
import 'package:diana/data/data_sources/auth/auth_remote_source.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/auth/login_info.dart';
import 'package:diana/data/remote_models/auth/refresh_info.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:diana/domain/repos/auth_repo.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class AuthRepoImpl extends AuthRepo {
  final NetWorkInfo netWorkInfo;
  final AuthRemoteSource remoteSource;
  final AuthLocalSource authLocalSource;

  AuthRepoImpl({
    this.netWorkInfo,
    this.remoteSource,
    this.authLocalSource,
  });

  @override
  Future<Either<Failure, bool>> changePass(
    String newPass1,
    String newPass2,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.changePass(newPass1, newPass2);
        log('API result is $result', name: 'changePass');
        return Right(result);
      } on FieldsException catch (error) {
        return Left(ChangePassFieldsFailure.fromFieldsException(
            json.decode(error.body)));
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> editUser(
      String firstName, String lastName, String email, String birthdate) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.editUser(firstName, lastName, email, birthdate);

        log('API result is $result', name: 'editUser');

        await authLocalSource.insertUser(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
            UserFieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getUser();

        log('API result is $result', name: 'getUser');

        await authLocalSource.insertUser(result);
        await authLocalSource.cacheUserId(result.userId);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, LoginInfo>> loginUser(
      String username, String password) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.loginUser(username, password);

        log('API result is $result', name: 'loginUser');

        await authLocalSource.insertUser(result.user);

        await authLocalSource.cacheToken(result.accessToken);
        await authLocalSource.cacheRefreshToken(result.refreshToken);
        await authLocalSource.cacheUserId(result.user.userId);

        return Right(result);
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure(message: error.message));
      } on NonFieldsException catch (error) {
        return Left(NonFieldsFailure.fromNonFieldsException(
            json.decode(error.message)));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.logoutUser();

        log('API result is $result', name: 'logoutUser');

        return Right(result);
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> registerUser(String firstName, String lastName,
      String username, String email, String birthdate, String password) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final timezone = await FlutterNativeTimezone.getLocalTimezone();

        final user = await remoteSource.registerUser(firstName, lastName,
            username, email, birthdate, password, timezone);

        log('API result is $user', name: 'registerUser');

        // user.timeZone = await FlutterNativeTimezone.getLocalTimezone();

        return (await loginUser(username, password))
            .fold((failure) => null, (result) async => Right(user));
      } on FieldsException catch (error) {
        return Left(
            UserFieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, RefreshInfo>> requestToken() async {
    if (await netWorkInfo.isConnected()) {
      try {
        kRefreshToken = await authLocalSource.getRefreshToken();

        log('requesting token with refresh: $kRefreshToken',
            name: 'requestToken');

        final result = await remoteSource.requestToken(kRefreshToken);

        log('API result is $result', name: 'requestToken');

        await authLocalSource.cacheToken(result.access);
        await authLocalSource.cacheRefreshToken(result.refresh);

        return Right(result);
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      } on UnAuthException {
        return Left(UnAuthFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> resetPass(String email) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.resetPass(email);

        log('API result is $result', name: 'resetPass');

        return Right(result);
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<String> getToken() {
    return authLocalSource.getToken();
  }

  @override
  Future<String> getRefreshToken() {
    return authLocalSource.getRefreshToken();
  }

  @override
  Future<String> getUserId() {
    return authLocalSource.getUserId();
  }

  @override
  Stream<UserData> watchUser() {
    return authLocalSource.watchUser(kUserId);
  }

  @override
  Future<void> deleteRefreshToken() async {
    return await authLocalSource.deleteRefreshToken();
  }

  @override
  Future<void> deleteToken() async {
    return await authLocalSource.deleteToken();
  }

  @override
  Future<void> deleteUserId() async {
    return await authLocalSource.deleteUserId();
  }

  @override
  Future<Either<Failure, User>> uploadProfileImage(File image) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.uploadProfileImage(image);

        log('API result is $result', name: 'uploadProfileImage');

        await authLocalSource.insertUser(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
            UserFieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
