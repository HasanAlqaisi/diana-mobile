import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/date_to_ymd_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:diana/injection_container.dart' as di;
import 'package:get/route_manager.dart';

class ProfileScreen extends StatelessWidget {
  static const route = '/profile';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: di.sl<ProfileController>(),
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
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
                  heightFactor: 0.85,
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
              Positioned(
                right: 30,
                top: 70,
                child: IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  iconSize: 30,
                  onPressed: () => _.onProfileChecked(),
                ),
              ),
              Positioned(
                left: 30,
                top: 70,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.9,
                  child: StreamBuilder<UserData>(
                    stream: _.watchUser(),
                    builder: (context, userSnapshot) {
                      final user = userSnapshot.data;
                      _.setInfo(user);

                      return Form(
                        key: _.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: profileHeroTag,
                              child: GestureDetector(
                                onTap: _.onProfileTapped,
                                child: user?.picture != null
                                    ? CachedNetworkImage(
                                        imageBuilder: (context, imgProvider) {
                                          return Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imgProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ));
                                        },
                                        imageUrl: user?.picture ?? "",
                                        placeholder: (context, s) => ClipRRect(
                                          borderRadius: BorderRadius.circular(45),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/profile_holder.jpg'),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                              'assets/profile_holder.jpg'),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: TextFormField(
                                controller: _.firstNameControlerField,
                                decoration: InputDecoration(
                                    labelText: 'First name',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFDEDEDE)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFDEDEDE)),
                                    ),
                                    labelStyle:
                                        TextStyle(color: Color(0xFF612EF3)),
                                    errorText: _.failure is UserFieldsFailure
                                        ? (_.failure as UserFieldsFailure?)
                                            ?.firstName
                                            ?.first
                                        : null),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return requireFieldMessage;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextFormField(
                                controller: _.lastNameControlerField,
                                decoration: InputDecoration(
                                    labelText: 'Last name',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFDEDEDE)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFDEDEDE)),
                                    ),
                                    labelStyle:
                                        TextStyle(color: Color(0xFF612EF3)),
                                    errorText: _.failure is UserFieldsFailure
                                        ? (_.failure as UserFieldsFailure?)
                                            ?.lastName
                                            ?.first
                                        : null),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return requireFieldMessage;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextFormField(
                                  controller: _.emailControlerField,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFDEDEDE)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFDEDEDE)),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Color(0xFF612EF3)),
                                      errorText: _.failure is UserFieldsFailure
                                          ? (_.failure as UserFieldsFailure?)
                                              ?.email
                                              ?.first
                                          : null),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return requireFieldMessage;
                                    }
                                    return null;
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextField(
                                controller: _.birthControlerField,
                                onTap: () async {
                                  final birthdate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2010),
                                    firstDate: DateTime(1910),
                                    lastDate: DateTime.now(),
                                  );
                                  _.birthControlerField.text =
                                      dateToDjangotring(birthdate)!;
                                },
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Date of Birth',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFDEDEDE)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFDEDEDE)),
                                    ),
                                    labelStyle:
                                        TextStyle(color: Color(0xFF612EF3)),
                                    errorText: _.failure is UserFieldsFailure
                                        ? (_.failure as UserFieldsFailure?)
                                            ?.birthdate
                                            ?.first
                                        : null),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
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
                                      onPressed: _.onForgotPassPressed),
                                  TextButton(
                                    child: Text('Log Out?'),
                                    onPressed: _.onLogoutClicked,
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
                                    child: Text('Version 1.3.0',
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
