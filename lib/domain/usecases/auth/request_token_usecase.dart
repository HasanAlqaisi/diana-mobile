import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/auth/refresh_info.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class RequestTokenUsecase {
  final AuthRepo authRepo;

  RequestTokenUsecase(this.authRepo);

  Future<Either<Failure, RefreshInfo>> call() {
    return authRepo.requestToken();
  }
}
