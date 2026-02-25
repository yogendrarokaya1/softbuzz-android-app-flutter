import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';
import 'package:softbuzz_app/features/news/domain/usecases/news_usecases.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum NewsLoadStatus { initial, loading, success, error }

class NewsListState {
  final NewsLoadStatus status;
  final List<NewsEntity> articles;
  final String? selectedCategory;
  final String? errorMessage;

  const NewsListState({
    this.status = NewsLoadStatus.initial,
    this.articles = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  NewsListState copyWith({
    NewsLoadStatus? status,
    List<NewsEntity>? articles,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return NewsListState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }
}

class NewsDetailState {
  final NewsLoadStatus status;
  final NewsEntity? article;
  final String? errorMessage;

  const NewsDetailState({
    this.status = NewsLoadStatus.initial,
    this.article,
    this.errorMessage,
  });

  NewsDetailState copyWith({
    NewsLoadStatus? status,
    NewsEntity? article,
    String? errorMessage,
  }) {
    return NewsDetailState(
      status: status ?? this.status,
      article: article ?? this.article,
      errorMessage: errorMessage,
    );
  }
}

// ── News List ViewModel ───────────────────────────────────────────────────────

final newsListViewModelProvider =
    NotifierProvider<NewsListViewModel, NewsListState>(NewsListViewModel.new);

class NewsListViewModel extends Notifier<NewsListState> {
  late final GetNewsUsecase _getNewsUsecase;

  @override
  NewsListState build() {
    _getNewsUsecase = ref.read(getNewsUsecaseProvider);
    return const NewsListState();
  }

  Future<void> getNews({String? category}) async {
    state = state.copyWith(
      status: NewsLoadStatus.loading,
      selectedCategory: category,
    );

    final result = await _getNewsUsecase(GetNewsParams(category: category));

    result.fold(
      (failure) => state = state.copyWith(
        status: NewsLoadStatus.error,
        errorMessage: failure.message,
      ),
      (articles) => state = state.copyWith(
        status: NewsLoadStatus.success,
        articles: articles,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ── News Detail ViewModel ─────────────────────────────────────────────────────

final newsDetailViewModelProvider =
    NotifierProvider<NewsDetailViewModel, NewsDetailState>(
      NewsDetailViewModel.new,
    );

class NewsDetailViewModel extends Notifier<NewsDetailState> {
  late final GetNewsBySlugUsecase _getNewsBySlugUsecase;

  @override
  NewsDetailState build() {
    _getNewsBySlugUsecase = ref.read(getNewsBySlugUsecaseProvider);
    return const NewsDetailState();
  }

  Future<void> loadArticle(String slug) async {
    state = state.copyWith(status: NewsLoadStatus.loading);

    final result = await _getNewsBySlugUsecase(slug);

    result.fold(
      (failure) => state = state.copyWith(
        status: NewsLoadStatus.error,
        errorMessage: failure.message,
      ),
      (article) => state = state.copyWith(
        status: NewsLoadStatus.success,
        article: article,
      ),
    );
  }

  void reset() {
    state = const NewsDetailState();
  }
}
