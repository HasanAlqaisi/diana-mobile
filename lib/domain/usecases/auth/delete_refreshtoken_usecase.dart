import 'package:diana/domain/repos/auth_repo.dart';

class DeleteRefreshTokenUsecase {
  final AuthRepo authRepo;

  DeleteRefreshTokenUsecase({this.authRepo});

  Future<void> call() async {
    return await authRepo.deleteRefreshToken();
  }
}
