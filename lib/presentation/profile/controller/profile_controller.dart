import 'dart:io';

import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/errors/handle_error.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
import 'package:diana/core/utils/progress_loader.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/domain/usecases/auth/change_pass_usecase.dart';
import 'package:diana/domain/usecases/auth/delete_refreshtoken_usecase.dart';
import 'package:diana/domain/usecases/auth/delete_token_usecase.dart';
import 'package:diana/domain/usecases/auth/delete_userid_usecase.dart';
import 'package:diana/domain/usecases/auth/edit_user_usecase.dart';
import 'package:diana/domain/usecases/auth/get_user_usecase.dart';
import 'package:diana/domain/usecases/auth/logout_user_usecase.dart';
import 'package:diana/domain/usecases/auth/upload_profile_image_usecase.dart';
import 'package:diana/domain/usecases/auth/watch_user_usecase.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
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
  final UploadProfileImageUsecase uploadProfileImageUsecase;

  final formKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final firstNameControlerField = TextEditingController();
  final lastNameControlerField = TextEditingController();
  final usernameControlerField = TextEditingController();
  final emailControlerField = TextEditingController();
  final birthControlerField = TextEditingController();

  File image;
  String pass1, pass2;
  Failure failure;
  Rx<Failure> changepassFailure = ChangePassFieldsFailure().obs;

  var isImageUploading = false.obs;

  ProfileController(
    this.getUserUsecase,
    this.editUserUsecase,
    this.watchUserUsecase,
    this.logoutUserUsecase,
    this.deleteTokenUsecase,
    this.deleteRefreshTokenUsecase,
    this.deleteUserIdUsecase,
    this.changePassUsecase,
    this.uploadProfileImageUsecase,
  );

  @override
  void onInit() async {
    super.onInit();
    await API.doRequest(
      body: () async {
        failure = null;
        update();
        return await getUserUsecase();
      },
      failedBody: (failure) {
        this.failure = failure;
        update();
        handleUserApiFailure(failure);
      },
    );

    ever(isImageUploading, (bool loading) {
      if (loading) {
        showLoaderDialog();
      } else {
        if (Get.isDialogOpen) Get.back();
      }
    });
  }

  Future<void> uploadProfileImage(File image) async {
    return await API.doRequest(
      body: () async {
        failure = null;
        update();
        isImageUploading(true);
        return await uploadProfileImageUsecase(image);
      },
      successBody: () {
        isImageUploading(false);
      },
      failedBody: (failure) {
        isImageUploading(false);
        handleUserApiFailure(failure);
      },
    );
  }

  Future<void> onProfileChecked() async {
    Get.dialog(
      AlertDialog(title: Center(child: CircularProgressIndicator())),
    );

    await API.doRequest(
        body: () async {
          failure = null;
          update();
          return await editUserUsecase(
            firstNameControlerField.text,
            lastNameControlerField.text,
            emailControlerField.text,
            birthControlerField.text,
          );
        },
        failedBody: (failure) {
          this.failure = failure;
          update();
          handleUserApiFailure(failure);
        },
        successBody: () {});

    Get.back();
  }

  void setInfo(UserData user) {
    firstNameControlerField.text = user?.firstName;
    lastNameControlerField.text = user?.lastName;
    usernameControlerField.text = user?.username;
    emailControlerField.text = user?.email;
    birthControlerField.text = user?.birthdate;
  }

  Future<void> onProfileTapped() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile?.path);
    await uploadProfileImage(image);
  }

  Stream<UserData> watchUser() => watchUserUsecase();

  Future<void> onLogoutClicked() async {
    return await API.doRequest(
      body: () async {
        failure = null;
        update();
        return await logoutUserUsecase();
      },
      failedBody: (failure) {
        this.failure = failure;
        update();
        handleUserApiFailure(failure);
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
        changepassFailure.value = null;
        update();
        return await changePassUsecase(pass1, pass2);
      },
      failedBody: (failure) {
        changepassFailure.value = failure;
        update();
        handleUserApiFailure(failure);
      },
      successBody: () {
        Get.back();
      },
    );
  }

  void onForgotPassPressed() {
    Get.dialog(
      Obx(
        () => AlertDialog(
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
                      if (value.trim().isEmpty) {
                        return requireFieldMessage;
                      }
                      return null;
                    },
                    errorText: changepassFailure.value
                            is ChangePassFieldsFailure
                        ? (changepassFailure.value as ChangePassFieldsFailure)
                            ?.pass1
                            ?.first
                        : null,
                  ),
                ),
                RoundedTextField(
                  labelText: 'Confirm password',
                  isObsecure: true,
                  errorText: changepassFailure.value is ChangePassFieldsFailure
                      ? (changepassFailure.value as ChangePassFieldsFailure)
                          ?.pass2
                          ?.first
                      : null,
                  validateRules: (value) {
                    pass2 = value;
                    if (value.trim().isEmpty) {
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
                onPressed: () async {
                  if (passwordFormKey.currentState.validate()) {
                    await changePass();
                  }
                },
                child: Text('OK')),
          ],
        ),
      ),
    );
  }
}
