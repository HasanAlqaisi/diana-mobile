import 'package:diana/core/constants/constants.dart';

class LocalValidators {
  static String emailValidation(String email) {
    if (email.trim().isEmpty) return requireFieldMessage;
    if (!email.contains('@')) return enterValidEmailMessage;
    return null;
  }
}
