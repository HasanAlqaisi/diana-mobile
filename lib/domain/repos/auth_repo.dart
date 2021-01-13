import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
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

  Future<Either<Failure, User>> editUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String birthdate,
    String password,
  );

  Future<Either<Failure, bool>> resetPass(String email);

  Future<Either<Failure, RefreshInfo>> requestToken(String refreshToken);
}
