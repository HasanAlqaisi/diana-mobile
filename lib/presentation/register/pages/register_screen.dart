import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/date_to_ymd_string.dart';
import 'package:diana/core/global_widgets/rounded_button.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
import 'package:diana/presentation/register/controller/registeration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:diana/injection_container.dart' as di;

import 'package:diana/core/constants/constants.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';

class RegisterScreen extends StatelessWidget {
  static String route = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: di.sl<RegistrationController>(),
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Color(0XFF612EF3),
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RoundedTextField(
                  isObsecure: false,
                  labelText: 'First name',
                  keyboardType: TextInputType.name,
                  errorText: controller.failure is UserFieldsFailure
                      ? (controller.failure as UserFieldsFailure?)
                          ?.firstName
                          ?.first
                      : null,
                  validateRules: (value) {
                    controller.firstName = value;
                    if (value != null && value.trim().isEmpty) {
                      return requireFieldMessage;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RoundedTextField(
                  isObsecure: false,
                  labelText: 'Last name',
                  keyboardType: TextInputType.name,
                  errorText: controller.failure is UserFieldsFailure
                      ? (controller.failure as UserFieldsFailure?)
                          ?.lastName
                          ?.first
                      : null,
                  validateRules: (value) {
                    controller.lastName = value;
                    if (value != null && value.trim().isEmpty) {
                      return requireFieldMessage;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RoundedTextField(
                  isObsecure: false,
                  labelText: 'username',
                  hintText: 'John203',
                  keyboardType: TextInputType.name,
                  errorText: controller.failure is UserFieldsFailure
                      ? (controller.failure as UserFieldsFailure?)
                          ?.username
                          ?.first
                      : null,
                  validateRules: (value) {
                    controller.username = value;
                    if (value != null && value.trim().isEmpty) {
                      return requireFieldMessage;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RoundedTextField(
                  keyboardType: TextInputType.emailAddress,
                  isObsecure: false,
                  labelText: 'email',
                  hintText: 'example@email.com',
                  errorText: controller.failure is UserFieldsFailure
                      ? (controller.failure as UserFieldsFailure?)?.email?.first
                      : null,
                  validateRules: (value) {
                    controller.email = value;
                    if (value != null)
                      return GetUtils.isEmail(value)
                          ? null
                          : enterValidEmailMessage;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Obx(() => RoundedTextField(
                      onTap: () async {
                        controller.birthdate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2010),
                          firstDate: DateTime(1910),
                          lastDate: DateTime.now(),
                        );
                        controller.birthString.value =
                            dateToDjangotring(controller.birthdate)!;
                      },
                      isReadOnly: true,
                      isObsecure: false,
                      keyboardType: TextInputType.text,
                      hintText: controller.birthString.value,
                      errorText: controller.failure is UserFieldsFailure
                          ? (controller.failure as UserFieldsFailure?)
                              ?.birthdate
                              ?.first
                          : null,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RoundedTextField(
                  isObsecure: true,
                  labelText: 'Password',
                  hintText: '********',
                  keyboardType: TextInputType.text,
                  errorText: controller.failure is UserFieldsFailure
                      ? (controller.failure as UserFieldsFailure?)
                          ?.password
                          ?.first
                      : null,
                  validateRules: (value) {
                    controller.password = value;
                    if (value != null && value.trim().isEmpty) {
                      return requireFieldMessage;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: controller.onSignupPressed,
                ),
              ),
              TextButton(
                onPressed: controller.onLoginPressed,
                style: TextButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Do you have an account?',
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(
                          text: ' Login', style: TextStyle(color: Colors.blue))
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
