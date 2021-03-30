import 'package:diana/domain/repos/auth_repo.dart';

class GetTokenUseCase {
  final AuthRepo authRepo;

  GetTokenUseCase({this.authRepo});

  Future<String> call() {
    return authRepo.getToken();
  }
}
