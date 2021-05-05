import 'package:diana/core/global_widgets/user_progress_image.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/profile/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

PreferredSizeWidget buildDianaAppBar({
  @required TabBar tabBar,
  @required Rx<UserData> user,
}) {
  return AppBar(
    title: Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0), //Not working
      child: Obx(
        () => Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'Hey, ', style: TextStyle(fontWeight: FontWeight.w300)),
              TextSpan(text: '${user?.value?.firstName ?? ''}'),
            ],
          ),
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
          child: Obx(() => UserProgressImage(user: user.value)),
        ),
      )
    ],
    bottom: tabBar,
  );
}
