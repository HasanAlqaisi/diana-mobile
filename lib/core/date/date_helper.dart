class DateHelper {
  static int mapToCorrectDayValue(int day) {
    return (day > 7 || day < 1) ? null : day - 1;
  }

  static DateTime getFirstDayOfWeek(DateTime currentDate) {
    return currentDate.subtract(Duration(days: currentDate.weekday - 1));
  }

  static DateTime getLastDayOfWeek(DateTime currentDate) {
    return currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday));
  }
}
