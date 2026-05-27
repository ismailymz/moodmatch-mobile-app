import 'content_item.dart';

class Mood {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final List<ContentItem> recommendations;

  Mood({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.recommendations,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    final moodId = json['id'] as String;
    final rawRecommendations = json['recommendations'] as List<dynamic>;

    return Mood(
      id: moodId,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String,
      recommendations: rawRecommendations
          .cast<Map<String, dynamic>>()
          .map((item) => ContentItem.fromJson(item, moodId))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'description': description,
      'recommendations': recommendations.map((item) => item.toJson()).toList(),
    };
  }
}
