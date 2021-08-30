import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class ResetPassUsecase {
  final AuthRepo? authRepo;

  ResetPassUsecase({this.authRepo});

  Future<Either<Failure, bool>> call(String email) {
    return authRepo!.resetPass(email);
  }
}
