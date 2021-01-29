import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/date_to_string_birthdate.dart';
import 'package:diana/domain/usecases/auth/register_user_usecase.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final RegisterUserUsecase registerUserUseCase;
  String firstName = '', lastName = '', username = '', email, password = '';
  DateTime birthdate;
  RxString birthString = 'YYYY-mm-DD'.obs;
  Failure failure;
  bool isLoading = false;

  RegistrationController(this.registerUserUseCase);

  void onRegisterClicked() async {
    isLoading = true;
    failure = null;
    update();

    final result = await registerUserUseCase(
        firstName, lastName, username, email, birthString.value, password);
    isLoading = false;
    update();

    result.fold((failure) {
      this.failure = failure;
    }, (_) => null);
  }
}
