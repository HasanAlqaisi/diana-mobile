import 'package:diana/domain/repos/auth_repo.dart';

class DeleteTokenUsecase {
  final AuthRepo? authRepo;

  DeleteTokenUsecase({this.authRepo});

  Future<void> call() async {
    return await authRepo!.deleteToken();
  }
}
