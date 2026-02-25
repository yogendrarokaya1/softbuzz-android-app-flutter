import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';

class NewsApiModel {
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

  NewsApiModel({
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

  factory NewsApiModel.fromJson(Map<String, dynamic> json) {
    return NewsApiModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      coverImage: json['coverImage'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      isBreaking: json['isBreaking'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      author: json['author'] ?? 'SoftBuzz Staff',
      readTime: json['readTime'] ?? 1,
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  NewsEntity toEntity() {
    return NewsEntity(
      id: id,
      title: title,
      slug: slug,
      summary: summary,
      content: content,
      coverImage: coverImage,
      category: category,
      status: status,
      isBreaking: isBreaking,
      isFeatured: isFeatured,
      author: author,
      readTime: readTime,
      tags: tags,
      views: views,
      publishedAt: publishedAt,
      createdAt: createdAt,
    );
  }
}
