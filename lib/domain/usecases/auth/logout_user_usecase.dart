import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class LogoutUserUsecase {
  final AuthRepo authRepo;

  LogoutUserUsecase(this.authRepo);

  Future<Either<Failure, bool>> call() {
    return authRepo.logoutUser();
  }
}
