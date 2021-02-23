String dateToYMDString(DateTime birth) {
  return '${birth.year}-${birth.month}-${birth.day}';
}

String dateToDjangotring(DateTime birth) {
  return '${birth.year}-${birth.month}-${birth.day}T15:13';
}
