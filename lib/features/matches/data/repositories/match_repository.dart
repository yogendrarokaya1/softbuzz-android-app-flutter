import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/features/matches/data/datasources/remote/match_remote_datasource.dart';
import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';
import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';
import 'package:softbuzz_app/features/matches/domain/repositories/match_repository.dart';

class MatchRepository implements IMatchRepository {
  final IMatchRemoteDataSource _remote;

  MatchRepository(this._remote);

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
  Future<Either<Failure, List<MatchEntity>>> getMatches({
    String? status,
    String? format,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final models = await _remote.getMatches(
        status: status,
        format: format,
        page: page,
        limit: limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getLiveMatches() async {
    try {
      final models = await _remote.getLiveMatches();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getUpcomingMatches({
    int limit = 10,
  }) async {
    try {
      final models = await _remote.getUpcomingMatches(limit: limit);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getRecentMatches({
    int limit = 10,
  }) async {
    try {
      final models = await _remote.getRecentMatches(limit: limit);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, HomeMatchesEntity>> getHomeMatches() async {
    try {
      final model = await _remote.getHomeMatches();
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatchById(String id) async {
    try {
      final model = await _remote.getMatchById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScorecardEntity>> getScorecard(String matchId) async {
    try {
      final model = await _remote.getScorecard(matchId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }
}

final matchRepositoryProvider = Provider<IMatchRepository>((ref) {
  return MatchRepository(ref.read(matchRemoteDataSourceProvider));
});
