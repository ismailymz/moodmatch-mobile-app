import 'package:flutter_test/flutter_test.dart';

import 'package:moodmatch_mobile_app/models/content_item.dart';

void main() {
  group('ContentItem Model Tests', () {

    test('fromJson creates a valid ContentItem object', () {
      final Map<String, dynamic> jsonMap = {
        'id': 'item_001',
        'type': 'movie',
        'title': 'The Matrix',
        'subtitle': 'Sci-Fi Action',
        'imageUrl': 'assets/images/matrix.png',
        'sourceUrl': 'https://example.com/matrix'
      };
      const String testMoodId = 'focused';

      final item = ContentItem.fromJson(jsonMap, testMoodId);

      expect(item.id, 'item_001');
      expect(item.type, ContentType.movie);
      expect(item.title, 'The Matrix');
      expect(item.subtitle, 'Sci-Fi Action');
      expect(item.moodId, 'focused');
      expect(item.imageUrl, 'assets/images/matrix.png');
      expect(item.sourceUrl, 'https://example.com/matrix');
    });

    test('toJson converts a ContentItem object to a valid Map', () {
      final item = ContentItem(
        id: 'item_002',
        type: ContentType.music,
        title: 'Bohemian Rhapsody',
        subtitle: 'Classic Rock',
        moodId: 'happy',
        imageUrl: 'assets/images/queen.png',
        sourceUrl: 'https://example.com/queen',
      );

      final jsonMap = item.toJson();

      expect(jsonMap['id'], 'item_002');
      expect(jsonMap['type'], 'music');
      expect(jsonMap['title'], 'Bohemian Rhapsody');
      expect(jsonMap['subtitle'], 'Classic Rock');
      expect(jsonMap['moodId'], 'happy');
      expect(jsonMap['imageUrl'], 'assets/images/queen.png');
      expect(jsonMap['sourceUrl'], 'https://example.com/queen');
    });
  });
}