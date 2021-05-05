import 'dart:developer';

import 'package:diana/core/constants/constants.dart';
import 'package:diana/domain/usecases/home/get_refresh_token_usecase.dart';
import 'package:diana/domain/usecases/home/get_token_usecase.dart';
import 'package:diana/domain/usecases/home/get_userid_usecase.dart';
import 'package:diana/presentation/home/home.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final GetTokenUseCase getTokenUseCase;
  final GetRefreshTokenUseCase getRefreshTokenUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  bool isLogged;

  HomeController(
    this.getTokenUseCase,
    this.getRefreshTokenUseCase,
    this.getUserIdUseCase,
  );

  @override
  void onInit() async {
    super.onInit();
    log('getting refresh token, userid, token', name: Home.route);
    kRefreshToken = await getRefreshTokenUseCase();
    kUserId = await getUserIdUseCase();
    kToken = await getTokenUseCase();
    log('got them\nrefresh token is $kRefreshToken\nuserid is : $kUserId\ntoken is $kToken',
        name: Home.route);
    isLogged = kToken != null ? true : false;
    update();
  }
}
