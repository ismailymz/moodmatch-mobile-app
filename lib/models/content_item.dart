enum ContentType { music, movie, tvSeries }

extension ContentTypeX on ContentType {
  String get displayName {
    switch (this) {
      case ContentType.music:
        return 'Music';
      case ContentType.movie:
        return 'Movie';
      case ContentType.tvSeries:
        return 'TV Series';
    }
  }

  static ContentType fromJson(String raw) {
    switch (raw.toLowerCase()) {
      case 'music':
        return ContentType.music;
      case 'movie':
        return ContentType.movie;
      case 'tvseries':
      case 'tv_series':
      case 'tv':
        return ContentType.tvSeries;
      default:
        throw ArgumentError('Unknown content type: $raw');
    }
  }
}

class ContentItem {
  final String id;
  final ContentType type;
  final String title;
  final String subtitle;
  final String moodId;
  final String? imageUrl;
  final String? sourceUrl;

  ContentItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.moodId,
    this.imageUrl,
    this.sourceUrl,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json, String moodId) {
    return ContentItem(
      id: json['id'] as String,
      type: ContentTypeX.fromJson(json['type'] as String),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      moodId: moodId,
      imageUrl: json['imageUrl'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'moodId': moodId,
      'imageUrl': imageUrl,
      'sourceUrl': sourceUrl,
    };
  }
}
