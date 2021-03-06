import 'dart:io';

import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/domain/usecases/auth/change_pass_usecase.dart';
import 'package:diana/domain/usecases/auth/delete_refreshtoken_usecase.dart';
import 'package:diana/domain/usecases/auth/delete_token_usecase.dart';
import 'package:diana/domain/usecases/auth/delete_userid_usecase.dart';
import 'package:diana/domain/usecases/auth/edit_user_usecase.dart';
import 'package:diana/domain/usecases/auth/get_user_usecase.dart';
import 'package:diana/domain/usecases/auth/logout_user_usecase.dart';
import 'package:diana/domain/usecases/auth/watch_user_usecase.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class ProfileController extends GetxController {
  final GetUserUsecase getUserUsecase;
  final EditUserUsecase editUserUsecase;
  final WatchUserUsecase watchUserUsecase;
  final LogoutUserUsecase logoutUserUsecase;
  final DeleteTokenUsecase deleteTokenUsecase;
  final DeleteRefreshTokenUsecase deleteRefreshTokenUsecase;
  final DeleteUserIdUsecase deleteUserIdUsecase;
  final ChangePassUsecase changePassUsecase;

  final formKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final nameControlerField = TextEditingController();
  final emailControlerField = TextEditingController();
  final birthControlerField = TextEditingController();

  final isEditLoading = false.obs;
  File image;
  String pass1, pass2;

  ProfileController(
    this.getUserUsecase,
    this.editUserUsecase,
    this.watchUserUsecase,
    this.logoutUserUsecase,
    this.deleteTokenUsecase,
    this.deleteRefreshTokenUsecase,
    this.deleteUserIdUsecase,
    this.changePassUsecase,
  );

  @override
  void onInit() async {
    super.onInit();
    await API.doRequest(
      body: () async {
        return await getUserUsecase();
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  @override
  void onClose() async {
    await API.doRequest(body: () async {
      isEditLoading.value = true;
      return await editUserUsecase(
        nameControlerField.text,
        nameControlerField.text,
        nameControlerField.text,
        emailControlerField.text,
        birthControlerField.text,
        image,
      );
    }, failedBody: (failure) {
      isEditLoading.value = false;
      Fluttertoast.showToast(msg: failureToString(failure));
    }, successBody: () {
      isEditLoading.value = false;
    });
    nameControlerField.dispose();
    emailControlerField.dispose();
    birthControlerField.dispose();
    super.onClose();
  }

  Stream<UserData> watchUser() => watchUserUsecase();

  Future<void> onLogoutClicked() async {
    return await API.doRequest(
      body: () async {
        return await logoutUserUsecase();
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
      successBody: () async {
        await Future.wait([
          deleteTokenUsecase(),
          deleteRefreshTokenUsecase(),
          deleteUserIdUsecase(),
        ]);
        Get.offAllNamed(LoginScreen.route);
      },
    );
  }

  Future<void> changePass() async {
    return await API.doRequest(
      body: () async {
        return await changePassUsecase(pass1, pass2);
      },
    );
  }
}
