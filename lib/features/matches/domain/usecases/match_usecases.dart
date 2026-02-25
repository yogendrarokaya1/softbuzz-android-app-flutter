import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/core/usecases/app_usecases.dart';
import 'package:softbuzz_app/features/matches/data/repositories/match_repository.dart';
import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';
import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';
import 'package:softbuzz_app/features/matches/domain/repositories/match_repository.dart';

// ── Params ────────────────────────────────────────────────────────────────────

class GetMatchesParams {
  final String? status;
  final String? format;
  final int page;
  final int limit;

  const GetMatchesParams({
    this.status,
    this.format,
    this.page = 1,
    this.limit = 10,
  });
}

// ── Get All Matches ───────────────────────────────────────────────────────────

class GetMatchesUsecase
    implements UsecaseWithParms<List<MatchEntity>, GetMatchesParams> {
  final IMatchRepository _repository;
  GetMatchesUsecase(this._repository);

  @override
  Future<Either<Failure, List<MatchEntity>>> call(GetMatchesParams params) {
    return _repository.getMatches(
      status: params.status,
      format: params.format,
      page: params.page,
      limit: params.limit,
    );
  }
}

final getMatchesUsecaseProvider = Provider<GetMatchesUsecase>((ref) {
  return GetMatchesUsecase(ref.read(matchRepositoryProvider));
});

// ── Get Live Matches ──────────────────────────────────────────────────────────

class GetLiveMatchesUsecase implements UsecaseWithoutParms<List<MatchEntity>> {
  final IMatchRepository _repository;
  GetLiveMatchesUsecase(this._repository);

  @override
  Future<Either<Failure, List<MatchEntity>>> call() {
    return _repository.getLiveMatches();
  }
}

final getLiveMatchesUsecaseProvider = Provider<GetLiveMatchesUsecase>((ref) {
  return GetLiveMatchesUsecase(ref.read(matchRepositoryProvider));
});

// ── Get Upcoming Matches ──────────────────────────────────────────────────────

class GetUpcomingMatchesUsecase
    implements UsecaseWithParms<List<MatchEntity>, int> {
  final IMatchRepository _repository;
  GetUpcomingMatchesUsecase(this._repository);

  @override
  Future<Either<Failure, List<MatchEntity>>> call(int limit) {
    return _repository.getUpcomingMatches(limit: limit);
  }
}

final getUpcomingMatchesUsecaseProvider = Provider<GetUpcomingMatchesUsecase>((
  ref,
) {
  return GetUpcomingMatchesUsecase(ref.read(matchRepositoryProvider));
});

// ── Get Recent Matches ────────────────────────────────────────────────────────

class GetRecentMatchesUsecase
    implements UsecaseWithParms<List<MatchEntity>, int> {
  final IMatchRepository _repository;
  GetRecentMatchesUsecase(this._repository);

  @override
  Future<Either<Failure, List<MatchEntity>>> call(int limit) {
    return _repository.getRecentMatches(limit: limit);
  }
}

final getRecentMatchesUsecaseProvider = Provider<GetRecentMatchesUsecase>((
  ref,
) {
  return GetRecentMatchesUsecase(ref.read(matchRepositoryProvider));
});

// ── Get Home Matches ──────────────────────────────────────────────────────────

class GetHomeMatchesUsecase implements UsecaseWithoutParms<HomeMatchesEntity> {
  final IMatchRepository _repository;
  GetHomeMatchesUsecase(this._repository);

  @override
  Future<Either<Failure, HomeMatchesEntity>> call() {
    return _repository.getHomeMatches();
  }
}

final getHomeMatchesUsecaseProvider = Provider<GetHomeMatchesUsecase>((ref) {
  return GetHomeMatchesUsecase(ref.read(matchRepositoryProvider));
});

// ── Get Match By Id ───────────────────────────────────────────────────────────

class GetMatchByIdUsecase implements UsecaseWithParms<MatchEntity, String> {
  final IMatchRepository _repository;
  GetMatchByIdUsecase(this._repository);

  @override
  Future<Either<Failure, MatchEntity>> call(String id) {
    return _repository.getMatchById(id);
  }
}

final getMatchByIdUsecaseProvider = Provider<GetMatchByIdUsecase>((ref) {
  return GetMatchByIdUsecase(ref.read(matchRepositoryProvider));
});

// ── Get Scorecard ─────────────────────────────────────────────────────────────

class GetScorecardUsecase implements UsecaseWithParms<ScorecardEntity, String> {
  final IMatchRepository _repository;
  GetScorecardUsecase(this._repository);

  @override
  Future<Either<Failure, ScorecardEntity>> call(String matchId) {
    return _repository.getScorecard(matchId);
  }
}

final getScorecardUsecaseProvider = Provider<GetScorecardUsecase>((ref) {
  return GetScorecardUsecase(ref.read(matchRepositoryProvider));
});
