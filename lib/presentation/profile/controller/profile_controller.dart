import 'dart:io';

import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
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
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

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
  final firstNameControlerField = TextEditingController();
  final lastNameControlerField = TextEditingController();
  final usernameControlerField = TextEditingController();
  final emailControlerField = TextEditingController();
  final birthControlerField = TextEditingController();

  bool shouldReturn = false;
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

  Future<bool> onWillPopExcute() async {
    Get.dialog(
      AlertDialog(title: Center(child: CircularProgressIndicator())),
    );

    await API.doRequest(body: () async {
      shouldReturn = false;
      return await editUserUsecase(
        firstNameControlerField.text,
        lastNameControlerField.text,
        usernameControlerField.text,
        emailControlerField.text,
        birthControlerField.text,
        image,
      );
    }, failedBody: (failure) {
      shouldReturn = false;
      Fluttertoast.showToast(msg: failureToString(failure));
    }, successBody: () {
      shouldReturn = true;
    });

    Get.back();
    return shouldReturn;
  }

  void setInfo(UserData user) {
    firstNameControlerField.text = user?.firstName;
    lastNameControlerField.text = user?.lastName;
    usernameControlerField.text = user?.username;
    emailControlerField.text = user?.email;
    birthControlerField.text = user?.birthdate;
  }

  void onProfileTapped() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile?.path);
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

  void onForgotPassPressed() {
    Get.dialog(
      AlertDialog(
        title: Text('Enter new password'),
        content: Form(
          key: passwordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RoundedTextField(
                  labelText: 'Password',
                  isObsecure: true,
                  validateRules: (value) {
                    pass1 = value;
                    if (value.isEmpty) {
                      return requireFieldMessage;
                    }
                    return null;
                  },
                ),
              ),
              RoundedTextField(
                labelText: 'Confirm password',
                isObsecure: true,
                validateRules: (value) {
                  pass2 = value;
                  if (value.isEmpty) {
                    return requireFieldMessage;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('close')),
          TextButton(
              onPressed: () {
                if (passwordFormKey.currentState.validate()) {
                  changePass();
                }
              },
              child: Text('OK')),
        ],
      ),
    );
  }
}
