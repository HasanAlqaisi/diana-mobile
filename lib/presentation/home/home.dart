import 'package:diana/presentation/home/home_controller.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:diana/presentation/nav/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:diana/injection_container.dart' as di;

class Home extends StatelessWidget {
  static const route = '/home';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: di.sl<HomeController>(),
        builder: (controller) {
          if (controller.isLogged == null) {
            return Container(color: Colors.white);
          }
          if (controller.isLogged!) {
            return Nav();
          } else {
            return LoginScreen();
          }
        });
  }
}
