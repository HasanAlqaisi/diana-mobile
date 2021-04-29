import 'package:diana/core/global_widgets/user_progress_image.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/profile/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

PreferredSizeWidget buildDianaAppBar({
  @required TabBar tabBar,
  @required UserData user,
}) {
  return AppBar(
    title: Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0), //Not working
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: 'Hey, ', style: TextStyle(fontWeight: FontWeight.w300)),
            TextSpan(text: '${user?.firstName ?? ''}'),
          ],
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
            Get.toNamed(ProfileScreen.route);
          },
          child: UserProgressImage(user: user),
        ),
      )
    ],
    bottom: tabBar,
  );
}
