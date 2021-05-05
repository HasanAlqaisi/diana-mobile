import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UserProgressImage extends StatelessWidget {
  final UserData user;

  const UserProgressImage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: profileHeroTag,
      child: CircularStepProgressIndicator(
          totalSteps: 100,
          currentStep: user?.dailyTaskProgress?.round() ?? 0,
          selectedColor: Color(0xFF00FFEF),
          unselectedColor: Colors.white,
          padding: 0,
          width: 40,
          stepSize: 3,
          child: user?.picture != null
              ? CachedNetworkImage(
                  imageBuilder: (context, imgProvider) {
                    return Container(
                        decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imgProvider,
                        fit: BoxFit.cover,
                      ),
                    ));
                  },
                  imageUrl: user.picture,
                  placeholder: (context, str) => _buildPlaceholderImage())
              : _buildPlaceholderImage()),
    );
  }

  Widget _buildPlaceholderImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: Image.asset('assets/profile_holder.jpg'));
  }
}
