import 'package:novena_lorenzo/core/content/content_loader.dart';

/// One day of the Bicol novena (Ikaduwang Kabtang proper).
class BikolNovenaDay {
  const BikolNovenaDay({
    required this.order,
    required this.dayName,
    required this.title,
    required this.reflection,
    required this.wordOfGod,
    required this.petitions,
  });

  final int order;
  final String dayName; // e.g. "Enot na Aldaw"
  final String title;
  final List<String> reflection;
  final String wordOfGod; // Tataramon nin Dios
  final List<String> petitions; // Ika-tolong Kabtang kahagadan
}

/// The complete Bicol novena "Rinibong Buhay para sa Dios".
class BikolNovena {
  const BikolNovena({
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.dailyPrayer,
    required this.praiseTitle,
    required this.antiphon,
    required this.openingPrayer,
    required this.canticleReference,
    required this.canticle,
    required this.canticleResponse,
    required this.partTwoIntro,
    required this.days,
    required this.partThreeTitle,
    required this.partThreeIntro,
    required this.petitionResponse,
    required this.closingPrayer,
  });

  // Enot na Kabtang
  final String title;
  final String subtitle;
  final String quote;
  final List<String> dailyPrayer;
  final String praiseTitle;
  final List<String> antiphon;
  final List<String> openingPrayer;
  final String canticleReference;
  final List<List<String>> canticle;
  final String canticleResponse;

  // Ikaduwang Kabtang
  final String partTwoIntro;
  final List<BikolNovenaDay> days;

  // Ika-tolong Kabtang
  final String partThreeTitle;
  final String partThreeIntro;
  final String petitionResponse;
  final String closingPrayer;
}

class NovenaBikolRepository {
  const NovenaBikolRepository();

  Future<BikolNovena> load() async {
    final part1 = await ContentLoader.load('enot_na_kabtang.json');
    final part2 = await ContentLoader.load('ikaduwang_kabtang.json');
    final part3 = await ContentLoader.load('ikatolong_kabtang.json');

    return ContentLoader.parse('ikaduwang_kabtang.json', 'Bicol novena', (_) {
      final praise = part1['pag-omaw_sa_Dios'];
      final petitions = {
        for (final item in part3['kahagadan'] as List)
          item['order'] as int: stringList(item['pamibi']),
      };
      final days = [
        for (final item in part2['proper'] as List)
          BikolNovenaDay(
            order: item['order'] as int,
            dayName: item['aldaw'] as String,
            title: item['title'] as String,
            reflection: stringList(item['reflection']),
            wordOfGod: item['tataramon_nin_Dios'] as String,
            petitions: petitions[item['order']] ?? const [],
          ),
      ]..sort((a, b) => a.order.compareTo(b.order));

      return BikolNovena(
        title: part1['title'] as String,
        subtitle: part1['subtitle'] as String,
        quote: part1['qoute'] as String,
        dailyPrayer: stringList(part1['pamibi_sa_oroaldaw']),
        praiseTitle: praise['title'] as String,
        antiphon: stringList(praise['antifona']),
        openingPrayer: stringList(praise['enot_na_pamibi']),
        canticleReference: praise['pamibi']['bible_verse'] as String,
        canticle: [
          for (final item in praise['pamibi']['lider'] as List)
            stringList(item['prayer']),
        ],
        canticleResponse: praise['pamibi']['gabos'] as String,
        partTwoIntro: part2['pamibi'] as String,
        days: days,
        partThreeTitle: part3['title'] as String,
        partThreeIntro: part3['pataratara'] as String,
        petitionResponse: part3['simbag'] as String,
        closingPrayer: part3['huring_pamibi'] as String,
      );
    });
  }
}
