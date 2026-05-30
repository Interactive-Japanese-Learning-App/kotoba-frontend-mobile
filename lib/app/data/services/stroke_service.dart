import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/stroke_model.dart';

class StrokeService {
  static Future<List<StrokeData>> loadStroke(
    String kana,
    String type,
  ) async {
    final path =
        'assets/stroke_json/$type/$kana.json';

    final jsonString =
        await rootBundle.loadString(path);

    final List data = json.decode(jsonString);

    return data
        .map((e) => StrokeData.fromJson(e))
        .toList();
  }
}