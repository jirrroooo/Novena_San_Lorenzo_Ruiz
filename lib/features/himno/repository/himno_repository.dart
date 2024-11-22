import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/features/himno/models/himno_model.dart';
import 'package:novena_lorenzo/utils/log_service.dart';

class HimnoRepository {
  LogService logService = LogService();

  Future<HimnoModel> getHimno() async {
    List<List<dynamic>> verses = [];

    try {
      String jsonString = await rootBundle.loadString('lib/data/himno.json');

      var decodedData = jsonDecode(jsonString);

      for (var item in decodedData["versos"]) {
        verses.add(item["verso"]);
      }

      return HimnoModel(chorus: decodedData["koro"], verses: verses);
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched biography data. Try again later."
      };

      await logService.logError(e.toString());

      throw Exception(jsonEncode(error));
    }
  }
}
