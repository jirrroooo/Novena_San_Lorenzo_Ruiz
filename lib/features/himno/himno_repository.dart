import 'package:novena_lorenzo/core/content/content_loader.dart';

class Hymn {
  const Hymn({required this.chorus, required this.verses});

  final List<String> chorus;
  final List<List<String>> verses;
}

class HimnoRepository {
  const HimnoRepository();

  Future<Hymn> load() {
    return ContentLoader.parse('himno.json', 'hymn lyrics', (json) {
      final verses = [...json['versos'] as List]
        ..sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
      return Hymn(
        chorus: stringList(json['koro']),
        verses: [for (final verse in verses) stringList(verse['verso'])],
      );
    });
  }
}
