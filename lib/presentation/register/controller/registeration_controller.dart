import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/errors/handle_error.dart';
import 'package:diana/domain/usecases/auth/register_user_usecase.dart';
import 'package:diana/presentation/nav/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final RegisterUserUsecase? registerUserUseCase;
  String? firstName = '', lastName = '', username = '', email, password = '';
  DateTime? birthdate;
  RxString birthString = 'YYYY-mm-DD'.obs;
  Failure? failure;
  bool isLoading = false;

  var formKey = GlobalKey<FormState>();

  RegistrationController(this.registerUserUseCase);

  void onSignupPressed() async {
    if (isLoading) return;

    if (formKey.currentState!.validate()) {
      isLoading = true;
      failure = null;
      update();

      final result = await (registerUserUseCase!(
          firstName!, lastName!, username!, email!, birthString.value, password!));
      isLoading = false;
      update();

      result.fold((failure) {
        this.failure = failure;
        update();
        handleUserApiFailure(failure);
      }, (_) => Get.offAllNamed(Nav.route));
    }
  }

  void onLoginPressed() {
    Get.back();
  }
}
