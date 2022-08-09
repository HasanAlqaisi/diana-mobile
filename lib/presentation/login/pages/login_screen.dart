import 'package:diana/presentation/login/controller/login_controller.dart';
import 'package:diana/core/global_widgets/rounded_button.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:diana/injection_container.dart' as di;

import 'package:diana/core/constants/constants.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginScreen extends StatelessWidget {
  static String route = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: di.sl<LoginController>(),
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
                      'Login',
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
                    labelText: 'username',
                    hintText: 'John203',
                    validateRules: (value) {
                      controller.username = value!;
                      if (value.trim().isEmpty) {
                        return requireFieldMessage;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RoundedTextField(
                    isObsecure: true,
                    labelText: 'Password',
                    hintText: '********',
                    validateRules: (value) {
                      controller.password = value ?? '';
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
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: controller.onLoginPressed,
                  ),
                ),
                TextButton(
                  onPressed: controller.onRegisterPressed,
                  style: TextButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'New member?',
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: ' Register',
                            style: TextStyle(color: Colors.blue))
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
