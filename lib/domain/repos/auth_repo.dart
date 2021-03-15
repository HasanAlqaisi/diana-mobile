import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/auth/login_info.dart';
import 'package:diana/data/remote_models/auth/refresh_info.dart';
import 'package:diana/data/remote_models/auth/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String birthdate,
    String password,
  );

  Future<Either<Failure, LoginInfo>> loginUser(
    String username,
    String password,
  );

  Future<Either<Failure, bool>> logoutUser();

  Future<Either<Failure, bool>> changePass(String newPass1, String newPass2);

  Future<Either<Failure, User>> getUser();

  Stream<UserData> watchUser();

  Future<Either<Failure, User>> editUser(
    String firstName,
    String lastName,
    // String username,
    String email,
    String birthdate,
  );

  Future<Either<Failure, User>> uploadProfileImage(File image);

  Future<Either<Failure, bool>> resetPass(String email);

  Future<Either<Failure, RefreshInfo>> requestToken();

  Future<String> getToken();

  Future<void> deleteToken();

  Future<String> getRefreshToken();

  Future<void> deleteRefreshToken();

  Future<String> getUserId();

  Future<void> deleteUserId();
}
