import 'dart:convert';

import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../models/mood.dart';

class LocalDataService {
  Future<List<Mood>> loadMoods() async {
    final jsonString = await rootBundle.loadString(
      AppConstants.contentJsonPath,
    );
    final rawMap = json.decode(jsonString) as Map<String, dynamic>;
    final moodList = rawMap['moods'] as List<dynamic>;

    return moodList
        .cast<Map<String, dynamic>>()
        .map((moodJson) => Mood.fromJson(moodJson))
        .toList();
  }
}
