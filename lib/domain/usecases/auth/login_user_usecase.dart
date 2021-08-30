import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/auth/login_info.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class LoginUserUsecase {
  final AuthRepo? authRepo;

  LoginUserUsecase(this.authRepo);

  Future<Either<Failure, LoginInfo>> call(String username, String password) {
    return authRepo!.loginUser(username, password);
  }
}
