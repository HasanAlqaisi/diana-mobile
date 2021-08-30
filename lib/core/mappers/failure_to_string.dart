import 'package:diana/core/errors/failure.dart';

String? failureToString(Failure failure) {
  if (failure is UnknownFailure) {
    print('UnknownFailure is $failure and its message is ${failure.message}');
    // return failure.message ?? 'Something went wrong!';
    return 'Something went wrong!';
  } else if (failure is NoInternetFailure) {
    return 'No internet connection';
  } else if (failure is NonFieldsFailure) {
    return failure.errors?.first;
  } else {
    print('Error is $failure and type is ${failure.runtimeType}');
    return failure.runtimeType.toString();
  }
}
