import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/domain/usecases/auth/login_user_usecase.dart';
import 'package:diana/presentation/nav/nav.dart';
import 'package:diana/presentation/register/pages/register_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  final LoginUserUsecase loginUserUseCase;
  String username = '', password = '';
  Failure failure;
  bool isLoading = false;

  var formKey = GlobalKey<FormState>();

  LoginController(this.loginUserUseCase);

  void onLoginPressed() async {
    if (isLoading) return;
    if (formKey.currentState.validate()) {
      isLoading = true;
      failure = null;
      update();

      final result = await loginUserUseCase(username, password);
      isLoading = false;
      update();

      result.fold((failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      }, (_) => Get.offAndToNamed(Nav.route));
    }
  }

  void onRegisterPressed() {
    Get.toNamed(RegisterScreen.route);
  }
}
