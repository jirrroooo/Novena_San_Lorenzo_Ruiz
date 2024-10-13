import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/widgets/scripture/models/scriptureModel.dart';

class ScriptureRepository {
  Future<ScriptureModel> getScripture(Translation translation) async {
    print("===> getScripture is Called");

    var random = Random();
    int randomInt = random.nextInt(20);

    var data;

    try {
      String jsonString =
          await rootBundle.loadString('./lib/data/scripture.json');

      data = jsonDecode(jsonString)["verses"][randomInt];
    } catch (e) {
      throw Exception("Failed to load scripture: ${e.toString()}");
    }

    ScriptureModel scriptureModel = ScriptureModel(
        verse: translation == Translation.bicol
            ? data["bicol_verse"]
            : data["english_verse"],
        text: translation == Translation.bicol
            ? data["bicol_text"]
            : data["english_text"]);

    print(scriptureModel);

    return scriptureModel;
  }
}
