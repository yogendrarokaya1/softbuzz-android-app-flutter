import 'package:dartz/dartz.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';

abstract interface class INewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews({
    String? category,
    int page,
    int limit,
  });
  Future<Either<Failure, NewsEntity>> getNewsBySlug(String slug);
  Future<Either<Failure, List<NewsEntity>>> getFeaturedNews();
  Future<Either<Failure, List<NewsEntity>>> getBreakingNews();
  Future<Either<Failure, List<NewsEntity>>> getLatestNews({int limit});
}
