import 'dart:math';

import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/content/content_loader.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/data/translation.dart';

class ScriptureVerse {
  const ScriptureVerse({required this.reference, required this.text});

  final String reference;
  final String text;
}

class ScriptureRepository {
  const ScriptureRepository();

  /// A random verse; each call site gets its own, independent pick.
  Future<ScriptureVerse> random(Translation translation) {
    return ContentLoader.parse('scripture.json', 'scripture verse', (json) {
      final verses = json['verses'] as List;
      final verse = verses[Random().nextInt(verses.length)];
      final isBicol = translation == Translation.bicol;
      return ScriptureVerse(
        reference: verse[isBicol ? 'bicol_verse' : 'english_verse'] as String,
        text: verse[isBicol ? 'bicol_text' : 'english_text'] as String,
      );
    });
  }
}

/// A card with a random scripture verse related to martyrdom and faith.
///
/// Each card loads its own verse; previously a single global bloc was shared,
/// so opening one screen changed the verse (and language) shown on another.
class ScriptureSliver extends StatelessWidget {
  const ScriptureSliver({super.key, this.translation});

  /// Language of the verse; a random one is picked when null.
  final Translation? translation;

  @override
  Widget build(BuildContext context) {
    final language =
        translation ??
        (Random().nextBool() ? Translation.bicol : Translation.english);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      sliver: ContentSliver<ScriptureVerse>(
        load: () => const ScriptureRepository().random(language),
        builder: (context, verse) =>
            SliverToBoxAdapter(child: _ScriptureCard(verse: verse)),
      ),
    );
  }
}

class _ScriptureCard extends StatelessWidget {
  const _ScriptureCard({required this.verse});

  final ScriptureVerse verse;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scale = AppSettingsScope.of(context).textScale;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.gold,
                  size: 32,
                ),
                Text(
                  verse.text,
                  style: textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 16 * scale,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    '— ${verse.reference}',
                    style: textTheme.labelLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
