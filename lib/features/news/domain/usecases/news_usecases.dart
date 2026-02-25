import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/core/usecases/app_usecases.dart';
import 'package:softbuzz_app/features/news/data/repositories/news_repository.dart';
import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';
import 'package:softbuzz_app/features/news/domain/repositories/news_repository.dart';

// ── Params ────────────────────────────────────────────────────────────────────

class GetNewsParams {
  final String? category;
  final int page;
  final int limit;

  const GetNewsParams({this.category, this.page = 1, this.limit = 12});
}

// ── Get News ──────────────────────────────────────────────────────────────────

class GetNewsUsecase
    implements UsecaseWithParms<List<NewsEntity>, GetNewsParams> {
  final INewsRepository _repository;
  GetNewsUsecase(this._repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(GetNewsParams params) {
    return _repository.getNews(
      category: params.category,
      page: params.page,
      limit: params.limit,
    );
  }
}

final getNewsUsecaseProvider = Provider<GetNewsUsecase>((ref) {
  return GetNewsUsecase(ref.read(newsRepositoryProvider));
});

// ── Get By Slug ───────────────────────────────────────────────────────────────

class GetNewsBySlugUsecase implements UsecaseWithParms<NewsEntity, String> {
  final INewsRepository _repository;
  GetNewsBySlugUsecase(this._repository);

  @override
  Future<Either<Failure, NewsEntity>> call(String slug) {
    return _repository.getNewsBySlug(slug);
  }
}

final getNewsBySlugUsecaseProvider = Provider<GetNewsBySlugUsecase>((ref) {
  return GetNewsBySlugUsecase(ref.read(newsRepositoryProvider));
});

// ── Get Featured ──────────────────────────────────────────────────────────────

class GetFeaturedNewsUsecase implements UsecaseWithoutParms<List<NewsEntity>> {
  final INewsRepository _repository;
  GetFeaturedNewsUsecase(this._repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call() {
    return _repository.getFeaturedNews();
  }
}

final getFeaturedNewsUsecaseProvider = Provider<GetFeaturedNewsUsecase>((ref) {
  return GetFeaturedNewsUsecase(ref.read(newsRepositoryProvider));
});

// ── Get Breaking ──────────────────────────────────────────────────────────────

class GetBreakingNewsUsecase implements UsecaseWithoutParms<List<NewsEntity>> {
  final INewsRepository _repository;
  GetBreakingNewsUsecase(this._repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call() {
    return _repository.getBreakingNews();
  }
}

final getBreakingNewsUsecaseProvider = Provider<GetBreakingNewsUsecase>((ref) {
  return GetBreakingNewsUsecase(ref.read(newsRepositoryProvider));
});

// ── Get Latest ────────────────────────────────────────────────────────────────

class GetLatestNewsUsecase implements UsecaseWithParms<List<NewsEntity>, int> {
  final INewsRepository _repository;
  GetLatestNewsUsecase(this._repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(int limit) {
    return _repository.getLatestNews(limit: limit);
  }
}

final getLatestNewsUsecaseProvider = Provider<GetLatestNewsUsecase>((ref) {
  return GetLatestNewsUsecase(ref.read(newsRepositoryProvider));
});
