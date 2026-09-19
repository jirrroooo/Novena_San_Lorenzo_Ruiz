/// Dates of the yearly novena (September 19–27) and feast (September 28).
abstract final class DevotionCalendar {
  static const int novenaStartDay = 19;
  static const int feastDay = 28;

  /// The novena day (1–9) for [date], or null outside the novena.
  static int? novenaDay(DateTime date) {
    if (date.month != DateTime.september) return null;
    final day = date.day - novenaStartDay + 1;
    return day >= 1 && day <= 9 ? day : null;
  }

  static bool isFeastDay(DateTime date) =>
      date.month == DateTime.september && date.day == feastDay;

  /// The 28th of each month is kept as a day of devotion.
  static bool isDevotionDay(DateTime date) => date.day == feastDay;
}
