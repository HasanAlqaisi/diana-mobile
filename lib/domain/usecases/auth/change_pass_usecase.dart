import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class ChangePassUsecase {
  final AuthRepo? authRepo;

  ChangePassUsecase({this.authRepo});

  Future<Either<Failure, bool>> call(String newPass1, String newPass2) {
    return authRepo!.changePass(newPass1, newPass2);
  }
}
