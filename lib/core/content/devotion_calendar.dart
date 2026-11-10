/// Dates of the yearly novena (September 19–27), the feast (September 28)
/// and the monthly day of devotion (the 28th).
abstract final class DevotionCalendar {
  static const int novenaStartDay = 19;
  static const int novenaDays = 9;
  static const int feastDay = 28;

  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// The novena day (1–9) for [date], or null outside the novena.
  static int? novenaDay(DateTime date) {
    if (date.month != DateTime.september) return null;
    final day = date.day - novenaStartDay + 1;
    return day >= 1 && day <= novenaDays ? day : null;
  }

  static bool isFeastDay(DateTime date) =>
      date.month == DateTime.september && date.day == feastDay;

  /// The 28th of each month is kept as a day of devotion.
  static bool isDevotionDay(DateTime date) => date.day == feastDay;

  /// The first day of the next novena, on or after [date].
  static DateTime nextNovenaStart(DateTime date) {
    final start = DateTime(date.year, DateTime.september, novenaStartDay);
    return _dateOnly(date).isAfter(start)
        ? DateTime(date.year + 1, DateTime.september, novenaStartDay)
        : start;
  }

  /// The next day of devotion (a 28th), on or after [date].
  static DateTime nextDevotionDay(DateTime date) => date.day <= feastDay
      ? DateTime(date.year, date.month, feastDay)
      : DateTime(date.year, date.month + 1, feastDay);

  /// Whole calendar days from [from] to [to], unaffected by daylight saving.
  static int daysBetween(DateTime from, DateTime to) => DateTime.utc(
    to.year,
    to.month,
    to.day,
  ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

  /// "November 28".
  static String formatDay(DateTime date) =>
      '${monthNames[date.month - 1]} ${date.day}';

  /// "today", "tomorrow" or "in 12 days".
  static String relative(int days) => switch (days) {
    0 => 'today',
    1 => 'tomorrow',
    _ => 'in $days days',
  };

  /// Same index all day, a different one tomorrow.
  static int dailyIndex(DateTime date, int length) =>
      daysBetween(DateTime(2000), date) % length;

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
