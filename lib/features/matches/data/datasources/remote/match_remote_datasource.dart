import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/api/api_client.dart';
import 'package:softbuzz_app/core/api/api_endpoints.dart';
import 'package:softbuzz_app/features/matches/data/models/match_api_model.dart';
import 'package:softbuzz_app/features/matches/data/models/scorecard_api_model.dart';

abstract interface class IMatchRemoteDataSource {
  Future<List<MatchApiModel>> getMatches({
    String? status,
    String? format,
    int page,
    int limit,
  });
  Future<List<MatchApiModel>> getLiveMatches();
  Future<List<MatchApiModel>> getUpcomingMatches({int limit});
  Future<List<MatchApiModel>> getRecentMatches({int limit});
  Future<HomeMatchesApiModel> getHomeMatches();
  Future<MatchApiModel> getMatchById(String id);
  Future<ScorecardApiModel> getScorecard(String matchId);
}

class MatchRemoteDataSource implements IMatchRemoteDataSource {
  final ApiClient _client;

  MatchRemoteDataSource(this._client);

  List<MatchApiModel> _parseList(dynamic raw) {
    if (raw == null) return [];
    return (raw as List)
        .map((j) => MatchApiModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  // Handles: { data: { matches: [...] } } OR { data: { data: [...] } } OR { data: [...] }
  List<MatchApiModel> _parseMatchesResponse(dynamic data) {
    if (data == null) return [];
    if (data is List) return _parseList(data);
    if (data is Map) {
      if (data['matches'] != null) return _parseList(data['matches']);
      if (data['data'] != null) return _parseList(data['data']);
    }
    return [];
  }

  @override
  Future<List<MatchApiModel>> getMatches({
    String? status,
    String? format,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _client.get(
      ApiEndpoints.matches,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (format != null) 'format': format,
      },
    );
    return _parseMatchesResponse(response.data['data']);
  }

  @override
  Future<List<MatchApiModel>> getLiveMatches() async {
    final response = await _client.get(ApiEndpoints.matchesLive);
    return _parseMatchesResponse(response.data['data']);
  }

  @override
  Future<List<MatchApiModel>> getUpcomingMatches({int limit = 10}) async {
    final response = await _client.get(
      ApiEndpoints.matchesUpcoming,
      queryParameters: {'limit': limit},
    );
    return _parseMatchesResponse(response.data['data']);
  }

  @override
  Future<List<MatchApiModel>> getRecentMatches({int limit = 10}) async {
    final response = await _client.get(
      ApiEndpoints.matchesRecent,
      queryParameters: {'limit': limit},
    );
    return _parseMatchesResponse(response.data['data']);
  }

  @override
  Future<HomeMatchesApiModel> getHomeMatches() async {
    final response = await _client.get(ApiEndpoints.matchesHome);
    return HomeMatchesApiModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<MatchApiModel> getMatchById(String id) async {
    final response = await _client.get(ApiEndpoints.matchById(id));
    return MatchApiModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<ScorecardApiModel> getScorecard(String matchId) async {
    final response = await _client.get(ApiEndpoints.scorecard(matchId));
    return ScorecardApiModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}

final matchRemoteDataSourceProvider = Provider<IMatchRemoteDataSource>((ref) {
  return MatchRemoteDataSource(ref.read(apiClientProvider));
});
