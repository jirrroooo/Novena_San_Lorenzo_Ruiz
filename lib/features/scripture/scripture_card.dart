import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_loader.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/data/translation.dart';

class ScriptureVerse {
  const ScriptureVerse({required this.reference, required this.text});

  final String reference;
  final String text;
}

class ScriptureRepository {
  const ScriptureRepository();

  /// The verse for [date]: the same all day, a different one tomorrow.
  Future<ScriptureVerse> forDate(Translation translation, DateTime date) {
    return ContentLoader.parse('scripture.json', 'scripture verse', (json) {
      final verses = json['verses'] as List;
      final verse = verses[DevotionCalendar.dailyIndex(date, verses.length)];
      final isBicol = translation == Translation.bicol;
      return ScriptureVerse(
        reference: verse[isBicol ? 'bicol_verse' : 'english_verse'] as String,
        text: verse[isBicol ? 'bicol_text' : 'english_text'] as String,
      );
    });
  }
}

/// Today's scripture verse on martyrdom and faith, set as plain text.
///
/// Shows nothing while loading or if the verse cannot be read: it is a
/// companion to the page, not its content.
class VerseOfTheDay extends StatefulWidget {
  const VerseOfTheDay({super.key, this.translation = Translation.english});

  final Translation translation;

  @override
  State<VerseOfTheDay> createState() => _VerseOfTheDayState();
}

class _VerseOfTheDayState extends State<VerseOfTheDay> {
  late final Future<ScriptureVerse> _verse = const ScriptureRepository()
      .forDate(widget.translation, DateTime.now());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final styles = ReadingStyles.of(context);

    return FutureBuilder<ScriptureVerse>(
      future: _verse,
      builder: (context, snapshot) {
        final verse = snapshot.data;
        if (verse == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verse for today',
              style: textTheme.titleSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Space.s),
            Text(verse.text, style: styles.emphasis),
            const SizedBox(height: Space.s),
            Text(
              verse.reference,
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}
