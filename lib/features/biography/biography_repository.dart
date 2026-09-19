import 'package:novena_lorenzo/core/content/content_loader.dart';

class BiographyFact {
  const BiographyFact(this.label, this.value);

  final String label;
  final String value;
}

class BiographySection {
  const BiographySection(this.title, this.points);

  final String title;
  final List<String> points;
}

class Biography {
  const Biography({required this.facts, required this.sections});

  final List<BiographyFact> facts;
  final List<BiographySection> sections;
}

class BiographyRepository {
  const BiographyRepository();

  Future<Biography> load() {
    return ContentLoader.parse('biography.json', 'biography', (json) {
      return Biography(
        facts: [
          for (final item in json['short_details'] as List)
            BiographyFact(item['title'] as String, item['detail'] as String),
        ],
        sections: [
          for (final item in json['long_details'] as List)
            BiographySection(
              item['title'] as String,
              stringList(item['detail']),
            ),
        ],
      );
    });
  }
}
