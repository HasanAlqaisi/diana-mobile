import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/auth_repo.dart';
import 'package:diana/domain/repos/task_repo.dart';

class GetTokenUseCase {
  final AuthRepo authRepo;

  GetTokenUseCase({this.authRepo});

  Future<String> call() {
    return authRepo.getToken();
  }
}
