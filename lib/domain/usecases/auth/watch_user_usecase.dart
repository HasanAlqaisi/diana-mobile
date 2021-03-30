import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class WatchUserUsecase {
  final AuthRepo authRepo;

  WatchUserUsecase({this.authRepo});

  Stream<UserData> call() {
    return authRepo.watchUser();
  }
}
