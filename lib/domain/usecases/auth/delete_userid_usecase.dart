import 'package:diana/domain/repos/auth_repo.dart';

class DeleteUserIdUsecase {
  final AuthRepo authRepo;

  DeleteUserIdUsecase({this.authRepo});

  Future<void> call() async {
    return await authRepo.deleteUserId();
  }
}
