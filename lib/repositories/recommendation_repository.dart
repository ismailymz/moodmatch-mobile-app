import 'dart:math';

import '../models/content_item.dart';
import '../models/mood.dart';
import '../services/local_data_service.dart';

class RecommendationRepository {
  RecommendationRepository(this._dataService);

  final LocalDataService _dataService;
  final Random _random = Random();
  List<Mood>? _cache;

  Future<List<Mood>> fetchMoods() async {
    if (_cache != null) {
      return _cache!;
    }

    _cache = await _dataService.loadMoods();
    return _cache!;
  }

  Future<Mood?> fetchMoodById(String id) async {
    final moods = await fetchMoods();

    try {
      return moods.firstWhere((mood) => mood.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ContentItem>> fetchRecommendationsForMood(
    String moodId, {
    int count = 3,
  }) async {
    final mood = await fetchMoodById(moodId);
    if (mood == null || mood.recommendations.isEmpty) {
      return [];
    }

    final shuffled = List<ContentItem>.from(mood.recommendations)
      ..shuffle(_random);
    return shuffled.take(count).toList();
  }

  Future<List<ContentItem>> searchContent(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return [];
    }

    final moods = await fetchMoods();
    final allItems = moods.expand((mood) => mood.recommendations);

    return allItems.where((item) {
      final title = item.title.toLowerCase();
      final subtitle = item.subtitle.toLowerCase();
      final type = item.type.displayName.toLowerCase();
      final moodId = item.moodId.toLowerCase();

      return title.contains(normalized) ||
          subtitle.contains(normalized) ||
          type.contains(normalized) ||
          moodId.contains(normalized);
    }).toList();
  }
}
