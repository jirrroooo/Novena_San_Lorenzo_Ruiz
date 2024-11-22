import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:novena_lorenzo/features/prayers/models/prayer_model.dart';
import 'package:novena_lorenzo/utils/log_service.dart';

class PrayerRepository {
  LogService logService = LogService();

  Future<List<PrayerModel>> getPrayers() async {
    List<PrayerModel> prayers = [];

    try {
      String jsonString = await rootBundle.loadString('lib/data/prayers.json');

      var decodedData = jsonDecode(jsonString);

      for (var item in decodedData["prayers"]) {
        prayers.add(PrayerModel(
            shortTitle: item["short_title"],
            englishTitle: item["english_title"],
            bicolTitle: item["bicol_title"],
            englishPrayer: item["english_prayer"],
            bicolPrayer: item["bicol_prayer"]));
      }

      return prayers;
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched prayer data. Try again later."
      };

      await logService.logError(e.toString());
      throw Exception(jsonEncode(error));
    }
  }
}
