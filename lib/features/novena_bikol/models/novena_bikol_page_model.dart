import 'package:novena_lorenzo/features/novena_bikol/models/novena_bikol_home_model.dart';

class NovenaBikolPageModel {
  // Enot na Kabtang

  final String enot_na_kabtang_title;
  final String subtitle;
  final String qoute;
  final List<dynamic> pamibi_sa_oroaldaw;
  final String pagomaw_title;
  final List<dynamic> pagomaw_antifona;
  final List<dynamic> enot_na_pamibi;
  final String gabos;
  final String bible_verse;
  final List<List<dynamic>> enot_na_kabtang_pamibi;

  // Ika-Duwang Kabtang

  final String ika_duwang_kabtang_pamibi;
  final NovenaBikolHomeModel proper;

  // Ika-Tolong Kabtang

  final String ika_tolong_kabtang_title;
  final String pataratara;
  final String simbag;
  final List<dynamic> ika_tolong_kabtang_pamibi;
  final String huring_pamibi;
  NovenaBikolPageModel({
    required this.enot_na_kabtang_title,
    required this.subtitle,
    required this.qoute,
    required this.pamibi_sa_oroaldaw,
    required this.pagomaw_title,
    required this.pagomaw_antifona,
    required this.enot_na_pamibi,
    required this.bible_verse,
    required this.gabos,
    required this.enot_na_kabtang_pamibi,
    required this.ika_duwang_kabtang_pamibi,
    required this.proper,
    required this.ika_tolong_kabtang_title,
    required this.pataratara,
    required this.simbag,
    required this.ika_tolong_kabtang_pamibi,
    required this.huring_pamibi,
  });
}
