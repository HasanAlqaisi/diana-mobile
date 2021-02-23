import 'package:diana/core/constants/_constants.dart';
import 'package:diana/domain/usecases/home/get_refresh_token_usecase.dart';
import 'package:diana/domain/usecases/home/get_token_usecase.dart';
import 'package:diana/domain/usecases/home/get_userid_usecase.dart';
import 'package:diana/presentation/home/home.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final GetTokenUseCase getTokenUseCase;
  final GetRefreshTokenUseCase getRefreshTokenUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  RxBool isLogged = false.obs;

  HomeController(
    this.getTokenUseCase,
    this.getRefreshTokenUseCase,
    this.getUserIdUseCase,
  );

  @override
  void onInit() async {
    super.onInit();
    debugPrint('${Home.route} => getting refresh token, userid, token');
    kRefreshToken = await getRefreshTokenUseCase();
    kUserId = await getUserIdUseCase();
    kToken = await getTokenUseCase();
    debugPrint(
        '${Home.route} => got them\nrefresh token is $kRefreshToken\nuserid is : $kUserId\ntoken is $kToken');
    isLogged.value = kToken != null ? true : false;
  }
}
