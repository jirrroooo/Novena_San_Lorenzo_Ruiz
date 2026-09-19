import 'package:flutter/material.dart';
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
    this.showHeading = true,
  });

  final Translation translation;
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
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                isBicol ? 'Bicol text' : 'English text',
                style: textTheme.titleSmall?.copyWith(color: scheme.primary),
              ),
            ),
          Card(
            child: Column(
              children: [
                for (final credit in credits)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: scheme.surfaceContainerHighest,
                      backgroundImage: AssetImage(credit.photo),
                    ),
                    title: Text(credit.name),
                    subtitle: Text(credit.role),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
