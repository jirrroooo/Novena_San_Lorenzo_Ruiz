import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/perpetual_novena/models/perpetual_novena_model.dart';
import 'package:novena_lorenzo/utils/log_service.dart';

class PerpetualNovenaRepository {
  LogService logService = LogService();

  Future<PerpetualNovenaModel> getPerpetualNovenaPrayer(
      Translation translation) async {
    var data;
    PerpetualNovenaModel perpetualNovenaModel;

    try {
      String jsonString =
          await rootBundle.loadString('lib/data/danay_na_novena.json');

      var decodedData = jsonDecode(jsonString);

      data = translation == Translation.bicol
          ? decodedData["bicol"]
          : decodedData["english"];

      perpetualNovenaModel = PerpetualNovenaModel(
          title: data["title"],
          prayer: data["prayer"],
          ourFather: data["our_father"],
          hailMary: data["hail_mary"],
          gloryBe: data["glory_be"],
          lastPrayer: data["last_prayer"]);
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched perpertual novena data. Try again later."
      };

      await logService.logError(e.toString());
      throw Exception(jsonEncode(error));
    }

    return perpetualNovenaModel;
  }
}
