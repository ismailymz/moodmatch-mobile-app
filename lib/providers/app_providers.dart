import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_item.dart';
import '../models/mood.dart';
import '../repositories/recommendation_repository.dart';
import '../services/local_data_service.dart';

final localDataServiceProvider = Provider<LocalDataService>((ref) {
  return LocalDataService();
});

final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return RecommendationRepository(ref.read(localDataServiceProvider));
});

class MoodListNotifier extends AsyncNotifier<List<Mood>> {
  @override
  Future<List<Mood>> build() async {
    return ref.read(recommendationRepositoryProvider).fetchMoods();
  }
}

final moodListProvider = AsyncNotifierProvider<MoodListNotifier, List<Mood>>(
  MoodListNotifier.new,
);

class SelectedMoodIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void setMood(String? moodId) {
    state = moodId;
  }

  void clear() {
    state = null;
  }
}

final selectedMoodIdProvider =
    NotifierProvider<SelectedMoodIdNotifier, String?>(
      SelectedMoodIdNotifier.new,
    );

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final selectedMoodProvider = Provider<Mood?>((ref) {
  final moodsAsync = ref.watch(moodListProvider);
  final selectedId = ref.watch(selectedMoodIdProvider);

  return moodsAsync.when(
    data: (moods) {
      if (moods.isEmpty) {
        return null;
      }

      if (selectedId == null) {
        return moods.first;
      }

      try {
        return moods.firstWhere((mood) => mood.id == selectedId);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (error, _) => null,
  );
});

final searchResultsProvider = FutureProvider.autoDispose<List<ContentItem>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider).trim();

  if (query.isEmpty) {
    return [];
  }

  return ref.read(recommendationRepositoryProvider).searchContent(query);
});

final moodRecommendationsProvider = FutureProvider.autoDispose<List<ContentItem>>(
  (ref) async {
    final selectedMood = ref.watch(selectedMoodProvider);
    if (selectedMood == null) {
      return [];
    }

    return ref
        .read(recommendationRepositoryProvider)
        .fetchRecommendationsForMood(selectedMood.id);
  },
);
