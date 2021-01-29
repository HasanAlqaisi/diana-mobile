import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/domain/usecases/auth/login_user_usecase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  final LoginUserUsecase loginUserUseCase;
  String username = '', password = '';
  Failure failure;
  bool isLoading = false;

  LoginController(this.loginUserUseCase);

  void onLoginClicked() async {
    isLoading = true;
    failure = null;
    update();

    final result = await loginUserUseCase(username, password);
    isLoading = false;
    update();

    result.fold((failure) {
      Fluttertoast.showToast(msg: failureToString(failure));
    }, (_) => null);
  }
}
