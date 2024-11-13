import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/features/biography/models/biography_model.dart';

class BiographyRepository {
  Future<BiographyModel> getBiograpy() async {
    final List<dynamic> shortTitles = [];
    final List<dynamic> shortDetails = [];
    final List<dynamic> longTitles = [];
    final List<List<dynamic>> longDetails = [];

    try {
      String jsonString =
          await rootBundle.loadString('lib/data/biography.json');

      var decodedData = jsonDecode(jsonString);

      for (var item in decodedData["short_details"]) {
        shortTitles.add(item["title"]);
        shortDetails.add(item["detail"]);
      }

      for (var item in decodedData["long_details"]) {
        longTitles.add(item["title"]);
        longDetails.add(item["detail"]);
      }

      return BiographyModel(
          shortTitles: shortTitles,
          shortDetails: shortDetails,
          longTitles: longTitles,
          longDetails: longDetails);
    } catch (e) {
      final error = {
        "title": "Error Occured",
        "description": "Cannot fetched biography data. Try again later."
      };

      throw Exception(jsonEncode(error));
    }
  }
}
