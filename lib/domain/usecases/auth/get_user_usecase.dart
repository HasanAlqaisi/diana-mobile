import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class GetUserUsecase {
  final AuthRepo authRepo;

  GetUserUsecase(this.authRepo);

  Future<Either<Failure, User>> call() {
    return authRepo.getUser();
  }
}
