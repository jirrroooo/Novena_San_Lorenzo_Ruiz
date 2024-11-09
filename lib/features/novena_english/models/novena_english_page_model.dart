import 'package:novena_lorenzo/features/novena_english/models/novena_english_home_model.dart';

class NovenaEnglishPageModel {
  final List<dynamic> act_of_contrition;
  final List<dynamic> opening_prayer;
  final NovenaEnglishHomeModel reflection;
  final String reflection_instruction;
  final List<dynamic> supplications;
  final String supplication_response;
  final String our_father;
  NovenaEnglishPageModel({
    required this.act_of_contrition,
    required this.opening_prayer,
    required this.reflection,
    required this.reflection_instruction,
    required this.supplications,
    required this.supplication_response,
    required this.our_father,
  });
}
