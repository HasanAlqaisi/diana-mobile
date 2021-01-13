class NonFieldsException implements Exception {
  final String message;

  NonFieldsException({this.message});
}

class FieldsException implements Exception {
  final String body;

  FieldsException({this.body});
}

class UnknownException implements Exception {
  final String message;

  UnknownException({this.message});
}

class UnAuthException implements Exception {}
