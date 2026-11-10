import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/data/translation.dart';

class _Credit {
  const _Credit(this.name, this.role, this.photo);

  final String name;
  final String role;
  final String photo;
}

const _bicolCredits = [
  _Credit(
    'Rev. Msgr. Crispin C. Bernarte Jr.',
    'Author',
    'assets/images/bernarte.webp',
  ),
  _Credit(
    'Rev. Msgr. Don Vito Pavilando',
    'Nihil Obstat',
    'assets/images/pavilando.webp',
  ),
  _Credit(
    '+ Most Rev. Jose C. Sorra, DD',
    'Imprimatur',
    'assets/images/sorra.webp',
  ),
];

const _englishCredits = [
  _Credit(
    'Rev. Msgr. Benedicto S. Aquino',
    'Nihil Obstat',
    'assets/images/aquino.webp',
  ),
  _Credit(
    'Rt. Rev. Msgr. Jose C. Abriol',
    'Imprimatur',
    'assets/images/abriol.webp',
  ),
];

/// Ecclesiastical approval and authorship of the Bicol or English texts.
class ApprovalCredits extends StatelessWidget {
  const ApprovalCredits({
    super.key,
    required this.translation,
    this.heading,
    this.showHeading = true,
  });

  final Translation translation;

  /// Label above the credits; defaults to "Bicol text" / "English text".
  final String? heading;
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isBicol = translation == Translation.bicol;
    final credits = isBicol ? _bicolCredits : _englishCredits;
    final footer = isBicol
        ? 'All rights reserved · Copyright 2004\nCommission on Lay Apostolate\nDiocese of Legazpi'
        : 'All rights reserved to the rightful owner';

    return Padding(
      padding: EdgeInsets.only(top: showHeading ? Space.l : Space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeading)
            GroupLabel(heading ?? (isBicol ? 'Bicol text' : 'English text')),
          ListGroup(
            dividerIndent: ListRow.textIndentWithBadge,
            children: [
              for (final credit in credits)
                ListRow(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: scheme.surfaceContainerHighest,
                    backgroundImage: AssetImage(credit.photo),
                  ),
                  title: credit.name,
                  subtitle: credit.role,
                ),
            ],
          ),
          const SizedBox(height: Space.m),
          Text(
            footer,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
