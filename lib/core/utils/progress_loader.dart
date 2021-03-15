import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoaderDialog() {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 16), child: Text("Loading...")),
      ],
    ),
  );
  Get.dialog(
    alert,
    barrierDismissible: false,
  );
}
