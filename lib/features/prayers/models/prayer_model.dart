class PrayerModel {
  final String shortTitle;
  final String englishTitle;
  final String? bicolTitle;
  final List<dynamic> englishPrayer;
  final List<dynamic>? bicolPrayer;
  PrayerModel({
    required this.shortTitle,
    required this.englishTitle,
    required this.bicolTitle,
    required this.englishPrayer,
    required this.bicolPrayer,
  });
}
