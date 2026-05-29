import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/content_item.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider did not initialize');
});

class FavoritesNotifier extends Notifier<List<ContentItem>> {
  static const _favoritesKey = 'favorite_items';

  @override
  List<ContentItem> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final String? favoritesJson = prefs.getString(_favoritesKey);

    if (favoritesJson != null) {
      final List<dynamic> decoded = json.decode(favoritesJson);

      return decoded
          .cast<Map<String, dynamic>>()
          .map((itemJson) => ContentItem.fromJson(itemJson, itemJson['moodId'] ?? 'favorite'))
          .toList();
    }

    return [];
  }

  Future<void> toggleFavorite(ContentItem item) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final isFavorite = state.any((fav) => fav.id == item.id);

    if (isFavorite) {
      state = state.where((fav) => fav.id != item.id).toList();
    } else {
      state = [...state, item];
    }

    final encoded = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<ContentItem>>(
  FavoritesNotifier.new,
);