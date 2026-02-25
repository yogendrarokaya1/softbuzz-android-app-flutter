import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/matches/domain/usecases/match_usecases.dart';
import 'package:softbuzz_app/features/matches/presentation/state/match_state.dart';

// ─────────────────────────────────────────────
// Match List ViewModel
// ─────────────────────────────────────────────

final matchListViewModelProvider =
    NotifierProvider<MatchListViewModel, MatchListState>(
      MatchListViewModel.new,
    );

class MatchListViewModel extends Notifier<MatchListState> {
  late final GetMatchesUsecase _getMatchesUsecase;
  late final GetLiveMatchesUsecase _getLiveMatchesUsecase;
  late final GetUpcomingMatchesUsecase _getUpcomingMatchesUsecase;
  late final GetRecentMatchesUsecase _getRecentMatchesUsecase;

  @override
  MatchListState build() {
    _getMatchesUsecase = ref.read(getMatchesUsecaseProvider);
    _getLiveMatchesUsecase = ref.read(getLiveMatchesUsecaseProvider);
    _getUpcomingMatchesUsecase = ref.read(getUpcomingMatchesUsecaseProvider);
    _getRecentMatchesUsecase = ref.read(getRecentMatchesUsecaseProvider);
    return const MatchListState();
  }

  Future<void> getMatches({String? status, String? format}) async {
    state = state.copyWith(status: MatchLoadStatus.loading);

    // Use dedicated endpoints — more efficient than filtering
    final result = await switch (status) {
      'live' => _getLiveMatchesUsecase(),
      'upcoming' => _getUpcomingMatchesUsecase(10),
      'completed' => _getRecentMatchesUsecase(10),
      _ => _getMatchesUsecase(GetMatchesParams(format: format)),
    };

    result.fold(
      (failure) => state = state.copyWith(
        status: MatchLoadStatus.error,
        errorMessage: failure.message,
      ),
      (matches) => state = state.copyWith(
        status: MatchLoadStatus.success,
        matches: matches,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ─────────────────────────────────────────────
// Match Detail ViewModel
// ─────────────────────────────────────────────

final matchDetailViewModelProvider =
    NotifierProvider<MatchDetailViewModel, MatchDetailState>(
      MatchDetailViewModel.new,
    );

class MatchDetailViewModel extends Notifier<MatchDetailState> {
  late final GetMatchByIdUsecase _getMatchByIdUsecase;
  late final GetScorecardUsecase _getScorecardUsecase;

  @override
  MatchDetailState build() {
    _getMatchByIdUsecase = ref.read(getMatchByIdUsecaseProvider);
    _getScorecardUsecase = ref.read(getScorecardUsecaseProvider);
    return const MatchDetailState();
  }

  Future<void> loadMatch(String id) async {
    state = state.copyWith(status: MatchLoadStatus.loading);

    final result = await _getMatchByIdUsecase(id);

    result.fold(
      (failure) => state = state.copyWith(
        status: MatchLoadStatus.error,
        errorMessage: failure.message,
      ),
      (match) {
        state = state.copyWith(status: MatchLoadStatus.success, match: match);
        // Auto-load scorecard
        loadScorecard(id);
      },
    );
  }

  Future<void> loadScorecard(String matchId) async {
    state = state.copyWith(scorecardStatus: MatchLoadStatus.loading);

    final result = await _getScorecardUsecase(matchId);

    result.fold(
      (failure) =>
          state = state.copyWith(scorecardStatus: MatchLoadStatus.error),
      (scorecard) => state = state.copyWith(
        scorecardStatus: MatchLoadStatus.success,
        scorecard: scorecard,
      ),
    );
  }

  void reset() {
    state = const MatchDetailState();
  }
}
