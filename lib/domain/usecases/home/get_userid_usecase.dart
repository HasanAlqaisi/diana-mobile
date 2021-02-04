import 'package:diana/domain/repos/auth_repo.dart';

class GetUserIdUseCase {
  final AuthRepo authRepo;

  GetUserIdUseCase({this.authRepo});

  Future<String> call() {
    return authRepo.getUserId();
  }
}
