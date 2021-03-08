import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:diana/injection_container.dart' as di;
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  static const route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GetBuilder<ProfileController>(
          init: di.sl<ProfileController>(),
          builder: (_) => Stack(
            children: [
              FractionallySizedBox(
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: Container(
                  color: Color(0xFF612EF3),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.85,
                  child: StreamBuilder<UserData>(
                    stream: _.watchUser(),
                    // ignore: missing_required_param
                    // initialData: UserData(),
                    builder: (context, userSnapshot) {
                      final user = userSnapshot.data;
                      _.nameControlerField.text = user?.firstName;
                      _.emailControlerField.text = user?.email;
                      _.birthControlerField.text = user?.birthdate;

                      return Form(
                        key: _.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery);
                                _.image = File(pickedFile?.path);
                                // await API.doRequest(body: () async {
                                //   _.isEditLoading.value = true;
                                //   return await _.editUserUsecase(
                                //       _.firstName.value,
                                //       _.lastName.value,
                                //       _.username.value,
                                //       _.email.value,
                                //       _.birthdate.value,
                                //       _.image);
                                // }, failedBody: (failure) {
                                //   _.isEditLoading.value = false;
                                //   Fluttertoast.showToast(
                                //       msg: failureToString(failure));
                                // }, successBody: () {
                                //   _.isEditLoading.value = false;
                                // });
                              },
                              child: CircleAvatar(
                                radius: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: user?.picture != null
                                      ? CachedNetworkImage(
                                          imageUrl: user?.picture,
                                        )
                                      : Image.asset(
                                          'assets/profile_holder.jpg'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: TextFormField(
                                controller: _.nameControlerField,
                                decoration: InputDecoration(
                                  labelText: 'Full name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return requireFieldMessage;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: TextFormField(
                                  controller: _.emailControlerField,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return requireFieldMessage;
                                    }
                                    return null;
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: TextField(
                                controller: _.birthControlerField,
                                onTap: () async {
                                  // controller.birthdate = await showDatePicker(
                                  //   context: context,
                                  //   initialDate: DateTime(2010),
                                  //   firstDate: DateTime(1910),
                                  //   lastDate: DateTime.now(),
                                  // );
                                  // controller.birthString.value =
                                  //     dateToDjangotring(controller.birthdate);
                                },
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Birthdate',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                          color: Color(0xFF636363),
                                          decoration:
                                              TextDecoration.underline),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Enter new password'),
                                              content: Form(
                                                key: _.passwordFormKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              vertical: 16.0),
                                                      child: RoundedTextField(
                                                        labelText: 'Password',
                                                        isObsecure: true,
                                                        validateRules:
                                                            (value) {
                                                          _.pass1 = value;
                                                          if (value.isEmpty) {
                                                            return requireFieldMessage;
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    RoundedTextField(
                                                      labelText:
                                                          'Confirm password',
                                                      isObsecure: true,
                                                      validateRules: (value) {
                                                        _.pass2 = value;
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
                                                      if (_.passwordFormKey
                                                          .currentState
                                                          .validate()) {
                                                        _.changePass();
                                                      }
                                                    },
                                                    child: Text('OK')),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Log Out?'),
                                    onPressed: () {
                                      _.onLogoutClicked();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 16.0),
                                    child: Text('Feedback',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0))),
                                  ),
                                  Divider(thickness: 1),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 16.0),
                                    child: Text('Report a problem',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0))),
                                  ),
                                  Divider(thickness: 1),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 16.0),
                                    child: Text('Version 1.0',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0))),
                                  ),
                                  Divider(thickness: 1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
