import 'package:diana/core/errors/failure.dart';

String failureToString(Failure failure) {
  if (failure is UnknownFailure) {
    print('Error ' + failure.message);
    return failure.message ?? 'Something went wrong!';
  } else if (failure is NoInternetFailure) {
    return 'No internet connection';
  } else if (failure is NonFieldsFailure) {
    return failure?.errors?.first;
  } else {
    print('Error ' + failure.toString());
    return failure.toString();
  }
}
