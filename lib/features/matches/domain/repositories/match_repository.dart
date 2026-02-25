import 'package:dartz/dartz.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';
import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';

abstract interface class IMatchRepository {
  Future<Either<Failure, List<MatchEntity>>> getMatches({
    String? status,
    String? format,
    int page,
    int limit,
  });
  Future<Either<Failure, List<MatchEntity>>> getLiveMatches();
  Future<Either<Failure, List<MatchEntity>>> getUpcomingMatches({int limit});
  Future<Either<Failure, List<MatchEntity>>> getRecentMatches({int limit});
  Future<Either<Failure, HomeMatchesEntity>> getHomeMatches();
  Future<Either<Failure, MatchEntity>> getMatchById(String id);
  Future<Either<Failure, ScorecardEntity>> getScorecard(String matchId);
}
