import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/core/global_widgets/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            FractionallySizedBox(
              heightFactor: 1.0,
              widthFactor: 1.0,
              child: Container(
                color: Color(0xFF6504C2),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: TextField(
                        //TODO: Search about how to show lable and hint text at the same time
                        decoration: InputDecoration(hintText: 'Full Name'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: TextField(
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
                          hintText: 'Date of Birth',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Color(0xFF636363),
                                  decoration: TextDecoration.underline),
                            ),
                            onPressed: () {
                              // Navigator.pushNamed(context, RegisterScreen.route);
                            },
                          ),
                          TextButton(
                            child: Text('Log Out?'),
                            onPressed: () {
                              // Navigator.pushNamed(context, RegisterScreen.route);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0),
                            child: Text('Feedback'),
                          ),
                          Divider(thickness: 1),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0),
                            child: Text('Report a problem'),
                          ),
                          Divider(thickness: 1),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0),
                            child: Text('Version 1.1'),
                          ),
                          Divider(thickness: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
