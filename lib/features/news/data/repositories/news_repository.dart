import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/features/news/data/datasources/remote/news_remote_datasource.dart';
import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';
import 'package:softbuzz_app/features/news/domain/repositories/news_repository.dart';

class NewsRepository implements INewsRepository {
  final INewsRemoteDataSource _remote;

  NewsRepository(this._remote);

  Failure _toFailure(Object e) {
    if (e is DioException) {
      final msg =
          e.response?.data?['message']?.toString() ??
          e.message ??
          'Network error';
      final statusCode = e.response?.statusCode;
      return ApiFailure(message: msg, statusCode: statusCode);
    }
    return ApiFailure(message: e.toString());
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews({
    String? category,
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final models = await _remote.getNews(
        category: category,
        page: page,
        limit: limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, NewsEntity>> getNewsBySlug(String slug) async {
    try {
      final model = await _remote.getNewsBySlug(slug);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getFeaturedNews() async {
    try {
      final models = await _remote.getFeaturedNews();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getBreakingNews() async {
    try {
      final models = await _remote.getBreakingNews();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getLatestNews({
    int limit = 10,
  }) async {
    try {
      final models = await _remote.getLatestNews(limit: limit);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }
}

final newsRepositoryProvider = Provider<INewsRepository>((ref) {
  return NewsRepository(ref.read(newsRemoteDataSourceProvider));
});
