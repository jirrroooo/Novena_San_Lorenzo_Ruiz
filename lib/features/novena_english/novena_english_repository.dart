import 'package:novena_lorenzo/core/content/content_loader.dart';

class EnglishNovenaDay {
  const EnglishNovenaDay({
    required this.order,
    required this.dayName,
    required this.title,
    required this.reflection,
  });

  final int order;
  final String dayName; // e.g. "First Day"
  final String title;
  final List<String> reflection;
}

class EnglishNovena {
  const EnglishNovena({
    required this.actOfContrition,
    required this.openingPrayer,
    required this.days,
    required this.reflectionInstruction,
    required this.supplications,
    required this.supplicationResponse,
    required this.ourFather,
  });

  final List<String> actOfContrition;
  final List<String> openingPrayer;
  final List<EnglishNovenaDay> days;
  final String reflectionInstruction;
  final List<String> supplications;
  final String supplicationResponse;
  final String ourFather;
}

class NovenaEnglishRepository {
  const NovenaEnglishRepository();

  Future<EnglishNovena> load() {
    return ContentLoader.parse('english_novena.json', 'English novena', (json) {
      final days = [
        for (final item in json['reflections'] as List)
          EnglishNovenaDay(
            order: item['order'] as int,
            dayName: item['subtitle'] as String,
            title: item['title'] as String,
            reflection: stringList(item['reflection']),
          ),
      ]..sort((a, b) => a.order.compareTo(b.order));

      return EnglishNovena(
        actOfContrition: stringList(json['act_of_contrition']),
        openingPrayer: stringList(json['opening_prayer']),
        days: days,
        reflectionInstruction: json['instruction_after_reflection'] as String,
        supplications: stringList(json['act_of_supplication']['supplications']),
        supplicationResponse: json['act_of_supplication']['response'] as String,
        ourFather: json['our_father'] as String,
      );
    });
  }
}
