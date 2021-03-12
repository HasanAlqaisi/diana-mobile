import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UserProgressImage extends StatelessWidget {
  final UserData user;

  const UserProgressImage({Key key, this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CircularStepProgressIndicator(
      totalSteps: 100,
      currentStep: user?.dailyTaskProgress?.round() ?? 0,
      selectedColor: Color(0xFF00FFEF),
      unselectedColor: Colors.white,
      padding: 0,
      width: 40,
      stepSize: 3,
      child: CircleAvatar(
        radius: 45,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: user?.picture != null
              ? CachedNetworkImage(
                  imageUrl: user.picture,
                  placeholder: (context, str) =>
                      Image.asset('assets/profile_holder.jpg'))
              : Image.asset('assets/profile_holder.jpg'),
        ),
      ),
    );
  }
}
