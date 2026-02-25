class TeamEntity {
  final String name;
  final String shortName;

  const TeamEntity({required this.name, required this.shortName});
}

class VenueEntity {
  final String stadiumName;
  final String city;
  final String country;

  const VenueEntity({
    required this.stadiumName,
    required this.city,
    required this.country,
  });
}

class MatchEntity {
  final String id;
  final String seriesName;
  final String matchNumber;
  final String format;
  final String status;
  final TeamEntity team1;
  final TeamEntity team2;
  final VenueEntity venue;
  final String scheduledDate;
  final String scheduledTime;
  final bool isInternational;
  final bool isFeatured;
  final String? result;
  final String? liveStatus;

  const MatchEntity({
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

  bool get isLive => status == 'live';
  bool get isUpcoming => status == 'upcoming';
  bool get isCompleted => status == 'completed';
}

class HomeMatchesEntity {
  final List<MatchEntity> live;
  final List<MatchEntity> upcoming;
  final List<MatchEntity> featured;

  const HomeMatchesEntity({
    required this.live,
    required this.upcoming,
    required this.featured,
  });
}
