import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_item.dart';
import 'app_providers.dart';

class BrowseFilterNotifier extends Notifier<Set<ContentType>> {
  @override
  Set<ContentType> build() {
    return {};
  }

  void toggleFilter(ContentType type) {
    if (state.contains(type)) {
      state = {...state}..remove(type);
    } else {
      state = {...state, type};
    }
  }

  void clear() {
    state = {};
  }
}

final browseFilterProvider =
    NotifierProvider<BrowseFilterNotifier, Set<ContentType>>(
  BrowseFilterNotifier.new,
);

final allContentItemsProvider = FutureProvider<List<ContentItem>>((ref) async {
  final moods = await ref.watch(moodListProvider.future);
  return moods.expand((mood) => mood.recommendations).toList();
});

final filteredContentItemsProvider = Provider<AsyncValue<List<ContentItem>>>((
  ref,
) {
  final allContentAsync = ref.watch(allContentItemsProvider);
  final filters = ref.watch(browseFilterProvider);

  return allContentAsync.whenData((items) {
    if (filters.isEmpty) {
      return items;
    }

    return items.where((item) => filters.contains(item.type)).toList();
  });
});

class BrowsePageNotifier extends Notifier<int> {
  @override
  int build() {
    return 1;
  }

  void nextPage() {
    state = state + 1;
  }

  void reset() {
    state = 1;
  }
}

final browsePageProvider = NotifierProvider<BrowsePageNotifier, int>(
  BrowsePageNotifier.new,
);

final paginatedContentProvider = Provider<AsyncValue<List<ContentItem>>>((
  ref,
) {
  final filteredContentAsync = ref.watch(filteredContentItemsProvider);
  final currentPage = ref.watch(browsePageProvider);

  return filteredContentAsync.whenData((items) {
    const itemsPerPage = 20;
    final endIndex = currentPage * itemsPerPage;
    return items.take(endIndex).toList();
  });
});

final hasMoreContentProvider = Provider<bool>((ref) {
  final filteredContentAsync = ref.watch(filteredContentItemsProvider);
  final paginatedContentAsync = ref.watch(paginatedContentProvider);

  return filteredContentAsync.maybeWhen(
    data: (filtered) {
      return paginatedContentAsync.maybeWhen(
        data: (paginated) => paginated.length < filtered.length,
        orElse: () => false,
      );
    },
    orElse: () => false,
  );
});
