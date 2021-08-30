import 'package:intl/intl.dart';

class DateHelper {
  static int? mapWeekDayToDjangoWay(int weekDay) {
    return (weekDay > 7 || weekDay < 1) ? null : weekDay - 1;
  }

  static String getCurrentYYYYmmDD(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static List<DateTime> getDatesFromWeekDays(List<int>? djangoWeekDays,
      [String? time]) {
    List<DateTime> dates = [];

    djangoWeekDays?.forEach((djangoWeekDay) {
      if (djangoWeekDay < 0) return;
      final weekDay = djangoWeekDay + 1;
      final hour = int.tryParse(time!.split(':').first);
      final minutes = int.tryParse(time.split(':')[1]);
      DateTime dateOfWeek = getFirstDayOfWeek(DateTime.now());
      DateTime lastDateOfWeek = getLastDayOfWeek(DateTime.now());

      while (dateOfWeek.isBefore(lastDateOfWeek)) {
        if (dateOfWeek.weekday == weekDay) {
          break;
        } else {
          dateOfWeek = dateOfWeek.add(Duration(days: 1));
        }
      }
      dateOfWeek = DateTime(
        dateOfWeek.year,
        dateOfWeek.month,
        dateOfWeek.day,
        hour ?? 00,
        minutes ?? 00,
      );
      dates.add(dateOfWeek);
    });
    return dates;
  }

  static DateTime getFirstDayOfWeek(DateTime currentDate) {
    return currentDate.subtract(Duration(days: currentDate.weekday - 1));
  }

  static DateTime getLastDayOfWeek(DateTime currentDate) {
    return currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday));
  }

  static String? stringDateOrNull(DateTime? date) {
    return date == null ? null : date.toString();
  }

  static String convertHour12FormatTo24Format(String timeIn12Format) {
    DateTime date = DateFormat.jm().parse(timeIn12Format);
    return DateFormat("HH:mm").format(date);
  }
}
