import 'dart:developer';

String dateToDjangotring(DateTime localDate) {
  return '${localDate.year}-${localDate.month}-${localDate.day}';
}

String dateAndTimeToDjango(DateTime localDate) {
  if (localDate == null) {
    log('localDate is null', name: 'dateAndTimeToDjango');
  }
  final date = localDate.toUtc();
  print('date in local zone $localDate');
  print('date in UTC $date');
  return '${date.year}-${date.month}-${date.day}T${date.hour}:${date.minute}';
}
