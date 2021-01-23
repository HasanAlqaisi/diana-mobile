class API {
  static int offsetExtractor(String url) {
    if (url != null) {
      final uri = Uri.parse(url);
      final offestString = uri.queryParameters['offset'];
      return int.tryParse(offestString);
    }
    return null;
  }
}