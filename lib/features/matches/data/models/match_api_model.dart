import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';

class TeamApiModel {
  final String name;
  final String shortName;

  TeamApiModel({required this.name, required this.shortName});

  factory TeamApiModel.fromJson(Map<String, dynamic> json) {
    return TeamApiModel(
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
    );
  }

  TeamEntity toEntity() => TeamEntity(name: name, shortName: shortName);
}

class VenueApiModel {
  final String stadiumName;
  final String city;
  final String country;

  VenueApiModel({
    required this.stadiumName,
    required this.city,
    required this.country,
  });

  factory VenueApiModel.fromJson(Map<String, dynamic> json) {
    return VenueApiModel(
      stadiumName: json['stadiumName'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  VenueEntity toEntity() =>
      VenueEntity(stadiumName: stadiumName, city: city, country: country);
}

class MatchApiModel {
  final String id;
  final String seriesName;
  final String matchNumber;
  final String format;
  final String status;
  final TeamApiModel team1;
  final TeamApiModel team2;
  final VenueApiModel venue;
  final String scheduledDate;
  final String scheduledTime;
  final bool isInternational;
  final bool isFeatured;
  final String? result;
  final String? liveStatus;

  MatchApiModel({
    required this.id,
    required this.seriesName,
    required this.matchNumber,
    required this.format,
    required this.status,
    required this.team1,
    required this.team2,
    required this.venue,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.isInternational,
    required this.isFeatured,
    this.result,
    this.liveStatus,
  });

  factory MatchApiModel.fromJson(Map<String, dynamic> json) {
    return MatchApiModel(
      id: json['_id'] ?? '',
      seriesName: json['seriesName'] ?? '',
      matchNumber: json['matchNumber']?.toString() ?? '',
      format: json['format'] ?? '',
      status: json['status'] ?? '',
      team1: TeamApiModel.fromJson(
        json['team1'] as Map<String, dynamic>? ?? {},
      ),
      team2: TeamApiModel.fromJson(
        json['team2'] as Map<String, dynamic>? ?? {},
      ),
      venue: VenueApiModel.fromJson(
        json['venue'] as Map<String, dynamic>? ?? {},
      ),
      scheduledDate: json['scheduledDate'] ?? '',
      scheduledTime: json['scheduledTime'] ?? '',
      isInternational: json['isInternational'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      result: json['result'],
      liveStatus: json['liveStatus'],
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      seriesName: seriesName,
      matchNumber: matchNumber,
      format: format,
      status: status,
      team1: team1.toEntity(),
      team2: team2.toEntity(),
      venue: venue.toEntity(),
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      isInternational: isInternational,
      isFeatured: isFeatured,
      result: result,
      liveStatus: liveStatus,
    );
  }
}

class HomeMatchesApiModel {
  final List<MatchApiModel> live;
  final List<MatchApiModel> upcoming;
  final List<MatchApiModel> featured;

  HomeMatchesApiModel({
    required this.live,
    required this.upcoming,
    required this.featured,
  });

  factory HomeMatchesApiModel.fromJson(Map<String, dynamic> json) {
    List<MatchApiModel> parseList(dynamic raw) {
      if (raw == null) return [];
      return (raw as List)
          .map((j) => MatchApiModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }

    return HomeMatchesApiModel(
      live: parseList(json['live']),
      upcoming: parseList(json['upcoming']),
      featured: parseList(json['featured']),
    );
  }

  HomeMatchesEntity toEntity() {
    return HomeMatchesEntity(
      live: live.map((m) => m.toEntity()).toList(),
      upcoming: upcoming.map((m) => m.toEntity()).toList(),
      featured: featured.map((m) => m.toEntity()).toList(),
    );
  }
}
