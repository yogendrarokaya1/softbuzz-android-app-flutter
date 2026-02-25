import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';
import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';

enum MatchLoadStatus { initial, loading, success, error }

class MatchListState {
  final MatchLoadStatus status;
  final List<MatchEntity> matches;
  final String? errorMessage;

  const MatchListState({
    this.status = MatchLoadStatus.initial,
    this.matches = const [],
    this.errorMessage,
  });

  MatchListState copyWith({
    MatchLoadStatus? status,
    List<MatchEntity>? matches,
    String? errorMessage,
  }) {
    return MatchListState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      errorMessage: errorMessage,
    );
  }
}

class MatchDetailState {
  final MatchLoadStatus status;
  final MatchEntity? match;
  final ScorecardEntity? scorecard;
  final MatchLoadStatus scorecardStatus;
  final String? errorMessage;

  const MatchDetailState({
    this.status = MatchLoadStatus.initial,
    this.match,
    this.scorecard,
    this.scorecardStatus = MatchLoadStatus.initial,
    this.errorMessage,
  });

  MatchDetailState copyWith({
    MatchLoadStatus? status,
    MatchEntity? match,
    ScorecardEntity? scorecard,
    MatchLoadStatus? scorecardStatus,
    String? errorMessage,
  }) {
    return MatchDetailState(
      status: status ?? this.status,
      match: match ?? this.match,
      scorecard: scorecard ?? this.scorecard,
      scorecardStatus: scorecardStatus ?? this.scorecardStatus,
      errorMessage: errorMessage,
    );
  }
}
