import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/features/novena_english/models/novena_english_home_model.dart';
import 'package:novena_lorenzo/features/novena_english/models/novena_english_page_model.dart';
import 'package:novena_lorenzo/utils/log_service.dart';

class NovenaEnglishRepository {
  LogService logService = LogService();

  Future<List<NovenaEnglishHomeModel>> getEnglishNovenaTitles() async {
    List<NovenaEnglishHomeModel> titles = [];

    try {
      String jsonString =
          await rootBundle.loadString('lib/data/english_novena.json');

      var decodedData = jsonDecode(jsonString);

      for (var data in decodedData["reflections"]) {
        titles.add(NovenaEnglishHomeModel(
            title: data["title"],
            subtitle: data["subtitle"],
            order: data["order"],
            reflection: data["reflection"]));
      }
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched novena titles. Try again later."
      };

      await logService.logError(e.toString());
      throw Exception(jsonEncode(error));
    }

    return titles;
  }

  Future<NovenaEnglishHomeModel> getReflection(int index) async {
    try {
      String jsonString =
          await rootBundle.loadString('lib/data/english_novena.json');

      var decodedData = jsonDecode(jsonString);

      for (var data in decodedData["reflections"]) {
        if (data["order"] == index + 1) {
          return NovenaEnglishHomeModel(
              title: data["title"],
              subtitle: data["subtitle"],
              order: data["order"],
              reflection: data["reflection"]);
        }
      }

      throw Exception(jsonEncode({
        "title": "Error Occurred",
        "description": "Novena Reflection not found. Try again later."
      }));
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched novena titles. Try again later."
      };

      await logService.logError(e.toString());
      throw Exception(jsonEncode(error));
    }
  }

  Future<NovenaEnglishPageModel> getEnglishNovenaDetail(int index) async {
    try {
      String jsonString =
          await rootBundle.loadString('lib/data/english_novena.json');

      var data = jsonDecode(jsonString);

      return NovenaEnglishPageModel(
          act_of_contrition: data["act_of_contrition"],
          opening_prayer: data["opening_prayer"],
          reflection: await getReflection(index),
          reflection_instruction: data["instruction_after_reflection"],
          supplications: data["act_of_supplication"]["supplications"],
          supplication_response: data["act_of_supplication"]["response"],
          our_father: data["our_father"]);
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched novena detail. Try again later."
      };

      await logService.logError(e.toString());
      throw Exception(jsonEncode(error));
    }
  }
}
