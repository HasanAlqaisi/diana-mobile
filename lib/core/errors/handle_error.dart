import 'package:diana/core/errors/failure.dart';
import 'package:fluttertoast/fluttertoast.dart';

handleTaskApiFailure(failure) {
  if (failure is UnknownFailure) {
    Fluttertoast.showToast(msg: failure.message);
  } else if (failure is NotFoundFailure) {
    Fluttertoast.showToast(msg: 'Item not found!');
  } else if (failure is NoInternetFailure) {
    Fluttertoast.showToast(msg: 'No Internet Connection!');
  } else if (failure is TaskFieldsFailure) {
    final nonFields = failure?.nonFields?.first;
    final date = failure?.date?.first;
    final reminder = failure?.reminder?.first;
    final deadline = failure?.deadline?.first;
    if (nonFields != null)
      Fluttertoast.showToast(msg: nonFields);
    else if (date != null)
      Fluttertoast.showToast(msg: date);
    else if (reminder != null)
      Fluttertoast.showToast(msg: reminder);
    else if (deadline != null) Fluttertoast.showToast(msg: deadline);
  } else if (failure is TagFieldsFailure) {
    Fluttertoast.showToast(msg: failure?.name?.first);
  }
}

handleSubtaskApiFailure(failure) {
  if (failure is UnknownFailure) {
    Fluttertoast.showToast(msg: failure.message);
  } else if (failure is NotFoundFailure) {
    Fluttertoast.showToast(msg: 'Item not found!');
  } else if (failure is NoInternetFailure) {
    Fluttertoast.showToast(msg: 'No Internet Connection!');
  }
}

handleTagApiFailure(failure) {
  if (failure is UnknownFailure) {
    Fluttertoast.showToast(msg: failure.message);
  } else if (failure is NotFoundFailure) {
    Fluttertoast.showToast(msg: 'Item not found!');
  } else if (failure is NoInternetFailure) {
    Fluttertoast.showToast(msg: 'No Internet Connection!');
  }
}

handleHabitApiFailure(failure) {
  if (failure is UnknownFailure) {
    Fluttertoast.showToast(msg: failure.message);
  } else if (failure is NotFoundFailure) {
    Fluttertoast.showToast(msg: 'Item not found!');
  } else if (failure is NoInternetFailure) {
    Fluttertoast.showToast(msg: 'No Internet Connection!');
  }
}

handleUserApiFailure(failure) {
  if (failure is UnknownFailure) {
    Fluttertoast.showToast(msg: failure.message);
  } else if (failure is NoInternetFailure) {
    Fluttertoast.showToast(msg: 'No Internet Connection!');
  } else if (failure is NonFieldsFailure) {
    return failure?.errors?.first;
  } else if (failure is UserFieldsFailure) {
    final image = failure?.image?.first;
    if (image != null) Fluttertoast.showToast(msg: image);
  }
}
