import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/features/novena_bikol/models/novena_bikol_home_model.dart';
import 'package:novena_lorenzo/features/novena_bikol/models/novena_bikol_page_model.dart';

class NovenaBikolRepository {
  Future<List<NovenaBikolHomeModel>> getBikolNovenaTitles() async {
    List<NovenaBikolHomeModel> titles = [];

    try {
      String jsonString =
          await rootBundle.loadString('lib/data/ikaduwang_kabtang.json');

      var decodedData = jsonDecode(jsonString);

      for (var data in decodedData["proper"]) {
        titles.add(NovenaBikolHomeModel(
            title: data["title"],
            aldaw: data["aldaw"],
            order: data["order"],
            reflection: data["reflection"],
            tataramon_nin_Dios: data["tataramon_nin_Dios"]));
      }
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched novena titles. Try again later."
      };

      throw Exception(jsonEncode(error));
    }

    return titles;
  }

  Future<NovenaBikolPageModel> getBikolNovenaDetail(int index) async {
    List<List<dynamic>> prayers = [];
    late NovenaBikolHomeModel model;
    List<dynamic> kahagadan = [];

    try {
      String jsonString1 =
          await rootBundle.loadString('lib/data/enot_na_kabtang.json');
      String jsonString2 =
          await rootBundle.loadString('lib/data/ikaduwang_kabtang.json');
      String jsonString3 =
          await rootBundle.loadString('lib/data/ikatolong_kabtang.json');

      var decodedData1 = jsonDecode(jsonString1);
      var decodedData2 = jsonDecode(jsonString2);
      var decodedData3 = jsonDecode(jsonString3);

      for (var item in decodedData1["pag-omaw_sa_Dios"]["pamibi"]["lider"]) {
        prayers.add(item["prayer"]);
      }

      for (var item in decodedData2["proper"]) {
        if (item["order"] == index + 1) {
          model = NovenaBikolHomeModel(
            aldaw: item["aldaw"],
            title: item["title"],
            order: item["order"],
            reflection: item["reflection"],
            tataramon_nin_Dios: item["tataramon_nin_Dios"],
          );
        }
      }

      for (var item in decodedData3["kahagadan"]) {
        if (item["order"] == index + 1) {
          kahagadan = item["pamibi"];
        }
      }

      return NovenaBikolPageModel(

          // Enot na kabtang
          enot_na_kabtang_title: decodedData1["title"],
          subtitle: decodedData1["subtitle"],
          qoute: decodedData1["qoute"],
          pamibi_sa_oroaldaw: decodedData1["pamibi_sa_oroaldaw"],
          pagomaw_title: decodedData1["pag-omaw_sa_Dios"]["title"],
          pagomaw_antifona: decodedData1["pag-omaw_sa_Dios"]["antifona"],
          gabos: decodedData1["pag-omaw_sa_Dios"]["pamibi"]["gabos"],
          enot_na_pamibi: decodedData1["pag-omaw_sa_Dios"]["enot_na_pamibi"],
          bible_verse: decodedData1["pag-omaw_sa_Dios"]["pamibi"]
              ["bible_verse"],
          enot_na_kabtang_pamibi: prayers,

          // Ika-duwang kabtang
          ika_duwang_kabtang_pamibi: decodedData2["pamibi"],
          proper: model,

          //Ika-tolong kabtang
          ika_tolong_kabtang_title: decodedData3["title"],
          pataratara: decodedData3["pataratara"],
          simbag: decodedData3["simbag"],
          ika_tolong_kabtang_pamibi: kahagadan,
          huring_pamibi: decodedData3["huring_pamibi"]);
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched novena details. Try again later."
      };

      throw Exception(jsonEncode(error));
    }
  }
}
