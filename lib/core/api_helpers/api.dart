import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
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
    Function body,
    void failedBody(Failure fail),
    Function successBody,
  }) async {
    (await body?.call()).fold((fail) async {
      print("FAIL happen => ${fail.runtimeType}");
      if (fail is UnAuthFailure) {
        final requestTokenResult = await _requestTokenUsecase(kRefreshToken);
        requestTokenResult.fold((requestTokenFail) {
          print("FAIL2 happen => ${requestTokenFail.runtimeType}");
          if (requestTokenFail is UnAuthFailure) {
            Fluttertoast.showToast(msg: 'Session ended');
            Get.offAllNamed(LoginScreen.route);
          } else {
            failedBody?.call(fail);
          }
        }, (r) => body?.call());
      } else {
        failedBody?.call(fail);
      }
    }, (r) => successBody?.call());
  }
}
