import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/api/api_client.dart';
import 'package:softbuzz_app/core/api/api_endpoints.dart';
import 'package:softbuzz_app/features/news/data/models/news_api_model.dart';

abstract interface class INewsRemoteDataSource {
  Future<List<NewsApiModel>> getNews({String? category, int page, int limit});
  Future<NewsApiModel> getNewsBySlug(String slug);
  Future<List<NewsApiModel>> getFeaturedNews();
  Future<List<NewsApiModel>> getBreakingNews();
  Future<List<NewsApiModel>> getLatestNews({int limit});
}

class NewsRemoteDataSource implements INewsRemoteDataSource {
  final ApiClient _client;

  NewsRemoteDataSource(this._client);

  List<NewsApiModel> _parseList(dynamic raw) {
    if (raw == null) return [];
    return (raw as List)
        .map((j) => NewsApiModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<NewsApiModel>> getNews({
    String? category,
    int page = 1,
    int limit = 12,
  }) async {
    final response = await _client.get(
      ApiEndpoints.news,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
      },
    );
    final payload = response.data['data'];
    final raw = payload is Map ? payload['data'] : payload;
    return _parseList(raw);
  }

  @override
  Future<NewsApiModel> getNewsBySlug(String slug) async {
    final response = await _client.get(ApiEndpoints.newsBySlug(slug));
    return NewsApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<NewsApiModel>> getFeaturedNews() async {
    final response = await _client.get(ApiEndpoints.newsFeatured);
    return _parseList(response.data['data']);
  }

  @override
  Future<List<NewsApiModel>> getBreakingNews() async {
    final response = await _client.get(ApiEndpoints.newsBreaking);
    return _parseList(response.data['data']);
  }

  @override
  Future<List<NewsApiModel>> getLatestNews({int limit = 10}) async {
    final response = await _client.get(
      ApiEndpoints.newsLatest,
      queryParameters: {'limit': limit},
    );
    return _parseList(response.data['data']);
  }
}

final newsRemoteDataSourceProvider = Provider<INewsRemoteDataSource>((ref) {
  return NewsRemoteDataSource(ref.read(apiClientProvider));
});
