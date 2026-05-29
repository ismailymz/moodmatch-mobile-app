import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moodmatch_mobile_app/models/content_item.dart';
import 'package:moodmatch_mobile_app/screens/detail_screen.dart';
import 'package:moodmatch_mobile_app/providers/favorites_provider.dart';

void main() {
  final mockItem = ContentItem(
    id: 'test_123',
    type: ContentType.movie,
    title: 'Inception',
    subtitle: 'Sci-Fi Thriller',
    imageUrl: '',
  );

  testWidgets('DetailScreen renders title, subtitle, and unfavourited icon correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          home: DetailScreen(item: mockItem),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Inception'), findsOneWidget); // Başlık ekranda var mı?
    expect(find.text('Sci-Fi Thriller'), findsOneWidget); // Alt başlık/Tür ekranda var mı?
    expect(find.byIcon(Icons.favorite_border), findsOneWidget); // Boş kalp ikonu var mı?
  });

  testWidgets('Toggling favorite button updates icon and shows Snackbar', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          home: DetailScreen(item: mockItem),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsNothing);

    expect(find.byIcon(Icons.favorite), findsOneWidget);

    expect(find.text('Added to favourites'), findsOneWidget);
  });
}