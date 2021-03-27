class DateHelper {
  static int mapWeekDayToDjangoWay(int weekDay) {
    return (weekDay > 7 || weekDay < 1) ? null : weekDay - 1;
  }

  static DateTime getFirstDayOfWeek(DateTime currentDate) {
    return currentDate.subtract(Duration(days: currentDate.weekday - 1));
  }

  static DateTime getLastDayOfWeek(DateTime currentDate) {
    return currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday));
  }

  static String stringDateOrNull(DateTime date){
    return date == null ? null : date.toString();
  }
}
