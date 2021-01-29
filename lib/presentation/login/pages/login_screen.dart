import 'package:diana/presentation/login/controller/login_controller.dart';
import 'package:diana/core/global_widgets/rounded_button.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
import 'package:diana/presentation/register/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GetBuilder<LoginController>(
        init: di.sl<LoginController>(),
        builder: (controller) {
          return Column(
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
                    controller.username = value;
                    if (value.isEmpty) {
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
                    controller.password = value;
                    if (value.isEmpty) {
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
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState.validate()) {
                            controller.onLoginClicked();
                          }
                        },
                ),
              ),
              FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
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
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.route);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
