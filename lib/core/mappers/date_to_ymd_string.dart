import 'dart:developer';

String dateToDjangotring(DateTime localDate) {
  if (localDate == null) {
    log('localDate is null', name: 'dateToDjangotring');
    return null;
  }
  return '${localDate.year}-${localDate.month}-${localDate.day}';
}

String dateAndTimeToDjango(DateTime localDate) {
  if (localDate == null) {
    log('localDate is null', name: 'dateAndTimeToDjango');
    return null;
  }
  final date = localDate.toUtc();
  print('date in local zone $localDate');
  print('date in UTC $date');
  return '${date.year}-${date.month}-${date.day}T${date.hour}:${date.minute}';
}
