class NewsEntity {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String coverImage;
  final String category;
  final String status;
  final bool isBreaking;
  final bool isFeatured;
  final String author;
  final int readTime;
  final List<String> tags;
  final int views;
  final String? publishedAt;
  final String createdAt;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.coverImage,
    required this.category,
    required this.status,
    required this.isBreaking,
    required this.isFeatured,
    required this.author,
    required this.readTime,
    required this.tags,
    required this.views,
    this.publishedAt,
    required this.createdAt,
  });

  String get displayDate => publishedAt ?? createdAt;

  String get categoryLabel => switch (category) {
    'top_stories' => 'Top Stories',
    'international' => 'International',
    'ipl' => 'IPL',
    'npl' => 'NPL',
    'domestic' => 'Domestic',
    _ => category,
  };
}
