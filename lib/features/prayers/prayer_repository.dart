import 'package:novena_lorenzo/core/content/content_loader.dart';

class Prayer {
  const Prayer({
    required this.shortTitle,
    required this.englishTitle,
    required this.englishText,
    this.bicolTitle,
    this.bicolText,
  });

  final String shortTitle;
  final String englishTitle;
  final List<String> englishText;
  final String? bicolTitle;
  final List<String>? bicolText;

  bool get hasBicol => bicolTitle != null && bicolText != null;
}

class PrayerRepository {
  const PrayerRepository();

  Future<List<Prayer>> load() {
    return ContentLoader.parse('prayers.json', 'prayers', (json) {
      return [
        for (final item in json['prayers'] as List)
          Prayer(
            shortTitle: item['short_title'] as String,
            englishTitle: item['english_title'] as String,
            englishText: stringList(item['english_prayer']),
            bicolTitle: item['bicol_title'] as String?,
            bicolText: item['bicol_prayer'] == null
                ? null
                : stringList(item['bicol_prayer']),
          ),
      ];
    });
  }
}
