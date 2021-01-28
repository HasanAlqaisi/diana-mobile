import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class RegisterUserUsecase {
  final AuthRepo authRepo;

  RegisterUserUsecase(this.authRepo);

  Future<Either<Failure, User>> call(
    String firstName,
    String lastName,
    String username,
    String email,
    String birthdate,
    String password,
  ) {
    return authRepo.registerUser(
        firstName, lastName, username, email, birthdate, password);
  }
}
