import 'package:diana/domain/repos/auth_repo.dart';

class GetRefreshTokenUseCase {
  final AuthRepo authRepo;

  GetRefreshTokenUseCase({this.authRepo});

  Future<String> call() {
    return authRepo.getRefreshToken();
  }
}
