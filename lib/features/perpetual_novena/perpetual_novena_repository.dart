import 'package:novena_lorenzo/core/content/content_loader.dart';
import 'package:novena_lorenzo/data/translation.dart';

class PerpetualNovena {
  const PerpetualNovena({
    required this.title,
    required this.prayer,
    required this.ourFather,
    required this.hailMary,
    required this.gloryBe,
    required this.lastPrayer,
  });

  final String title;
  final List<String> prayer;
  final String ourFather;
  final String hailMary;
  final String gloryBe;
  final List<String> lastPrayer;
}

class PerpetualNovenaRepository {
  const PerpetualNovenaRepository();

  Future<PerpetualNovena> load(Translation translation) {
    return ContentLoader.parse('danay_na_novena.json', 'perpetual novena', (
      json,
    ) {
      final data = json[translation == Translation.bicol ? 'bicol' : 'english'];
      return PerpetualNovena(
        title: data['title'] as String,
        prayer: stringList(data['prayer']),
        ourFather: data['our_father'] as String,
        hailMary: data['hail_mary'] as String,
        gloryBe: data['glory_be'] as String,
        lastPrayer: stringList(data['last_prayer']),
      );
    });
  }
}
