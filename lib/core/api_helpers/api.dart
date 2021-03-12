import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:diana/injection_container.dart' as di;

class API {
  static RequestTokenUsecase _requestTokenUsecase =
      di.sl<RequestTokenUsecase>();
  static int offsetExtractor(String url) {
    if (url != null) {
      final uri = Uri.parse(url);
      final offestString = uri.queryParameters['offset'];
      return int.tryParse(offestString);
    }
    return null;
  }

  static Future<void> doRequest({
    Future<dynamic>  body(),
    void failedBody(Failure fail),
    Function successBody,
  }) async {
    return (await body.call()).fold((fail) async {
      log(
        "${body.toString()} ",
        name: 'doRequest',
        error: {"data": '${fail.runtimeType} happen => ${fail.toString()}'},
      );
      if (fail is UnAuthFailure) {
        log('Requesting token', name: 'doRequest');
        final requestTokenResult = await _requestTokenUsecase();
        requestTokenResult.fold((requestTokenFail) {
          log(
            "${body.toString()} happened in requesting token",
            name: 'doRequest',
            error: {"data": '${fail.runtimeType} happen => ${fail.toString()}'},
          );
          if (requestTokenFail is UnAuthFailure) {
            Fluttertoast.showToast(msg: 'Session ended');
            Get.offAllNamed(LoginScreen.route);
          } else {
            failedBody?.call(fail);
          }
        }, (r) async => (await body?.call()));
      } else {
        return failedBody?.call(fail);
      }
    }, (r) => successBody?.call());
  }
}
