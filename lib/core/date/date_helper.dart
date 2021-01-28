class DateHelper {
  static int mapToCorrectDayValue(int day) {
    if (day == 1)
      return 0;
    else if (day == 2)
      return 1;
    else if (day == 3)
      return 2;
    else if (day == 4)
      return 3;
    else if (day == 5)
      return 4;
    else if (day == 6)
      return 5;
    else if (day == 7)
      return 6;
    else
      return null;
  }

  static DateTime getFirstDayOfWeek(DateTime currentDate) {
    return currentDate.subtract(Duration(days: currentDate.weekday - 1));
  }

  static DateTime getLastDayOfWeek(DateTime currentDate) {
    return currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday));
  }
}
