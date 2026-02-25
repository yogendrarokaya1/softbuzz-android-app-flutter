import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';

class BatsmanApiModel {
  final String name;
  final String dismissal;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double strikeRate;
  final bool isNotOut;

  BatsmanApiModel({
    required this.name,
    required this.dismissal,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.isNotOut,
  });

  factory BatsmanApiModel.fromJson(Map<String, dynamic> json) {
    return BatsmanApiModel(
      name: json['name'] ?? '',
      dismissal: json['dismissal'] ?? 'not out',
      runs: json['runs'] ?? 0,
      balls: json['balls'] ?? 0,
      fours: json['fours'] ?? 0,
      sixes: json['sixes'] ?? 0,
      strikeRate: (json['strikeRate'] ?? 0).toDouble(),
      isNotOut: json['isNotOut'] ?? false,
    );
  }

  BatsmanEntity toEntity() {
    return BatsmanEntity(
      name: name,
      dismissal: dismissal,
      runs: runs,
      balls: balls,
      fours: fours,
      sixes: sixes,
      strikeRate: strikeRate,
      isNotOut: isNotOut,
    );
  }
}

class BowlerApiModel {
  final String name;
  final double overs;
  final int maidens;
  final int runs;
  final int wickets;
  final double economy;
  final int noBalls;
  final int wides;

  BowlerApiModel({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
    required this.noBalls,
    required this.wides,
  });

  factory BowlerApiModel.fromJson(Map<String, dynamic> json) {
    return BowlerApiModel(
      name: json['name'] ?? '',
      overs: (json['overs'] ?? 0).toDouble(),
      maidens: json['maidens'] ?? 0,
      runs: json['runs'] ?? 0,
      wickets: json['wickets'] ?? 0,
      economy: (json['economy'] ?? 0).toDouble(),
      noBalls: json['noBalls'] ?? 0,
      wides: json['wides'] ?? 0,
    );
  }

  BowlerEntity toEntity() {
    return BowlerEntity(
      name: name,
      overs: overs,
      maidens: maidens,
      runs: runs,
      wickets: wickets,
      economy: economy,
      noBalls: noBalls,
      wides: wides,
    );
  }
}

class ExtrasApiModel {
  final int wides;
  final int noBalls;
  final int byes;
  final int legByes;
  final int penalty;
  final int total;

  ExtrasApiModel({
    required this.wides,
    required this.noBalls,
    required this.byes,
    required this.legByes,
    required this.penalty,
    required this.total,
  });

  factory ExtrasApiModel.fromJson(Map<String, dynamic> json) {
    return ExtrasApiModel(
      wides: json['wides'] ?? 0,
      noBalls: json['noBalls'] ?? 0,
      byes: json['byes'] ?? 0,
      legByes: json['legByes'] ?? 0,
      penalty: json['penalty'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  ExtrasEntity toEntity() {
    return ExtrasEntity(
      wides: wides,
      noBalls: noBalls,
      byes: byes,
      legByes: legByes,
      penalty: penalty,
      total: total,
    );
  }
}

class FowApiModel {
  final int wicketNumber;
  final int runs;
  final double overs;
  final String batsmanName;

  FowApiModel({
    required this.wicketNumber,
    required this.runs,
    required this.overs,
    required this.batsmanName,
  });

  factory FowApiModel.fromJson(Map<String, dynamic> json) {
    return FowApiModel(
      wicketNumber: json['wicketNumber'] ?? 0,
      runs: json['runs'] ?? 0,
      overs: (json['overs'] ?? 0).toDouble(),
      batsmanName: json['batsmanName'] ?? '',
    );
  }

  FowEntity toEntity() {
    return FowEntity(
      wicketNumber: wicketNumber,
      runs: runs,
      overs: overs,
      batsmanName: batsmanName,
    );
  }
}

class InningsApiModel {
  final int inningsNumber;
  final String battingTeam;
  final String bowlingTeam;
  final int totalRuns;
  final int totalWickets;
  final double totalOvers;
  final double runRate;
  final bool isCompleted;
  final bool isDeclared;
  final List<BatsmanApiModel> batting;
  final List<BowlerApiModel> bowling;
  final ExtrasApiModel extras;
  final List<FowApiModel> fallOfWickets;

  InningsApiModel({
    required this.inningsNumber,
    required this.battingTeam,
    required this.bowlingTeam,
    required this.totalRuns,
    required this.totalWickets,
    required this.totalOvers,
    required this.runRate,
    required this.isCompleted,
    required this.isDeclared,
    required this.batting,
    required this.bowling,
    required this.extras,
    required this.fallOfWickets,
  });

  factory InningsApiModel.fromJson(Map<String, dynamic> json) {
    return InningsApiModel(
      inningsNumber: json['inningsNumber'] ?? 1,
      battingTeam: json['battingTeam'] ?? '',
      bowlingTeam: json['bowlingTeam'] ?? '',
      totalRuns: json['totalRuns'] ?? 0,
      totalWickets: json['totalWickets'] ?? 0,
      totalOvers: (json['totalOvers'] ?? 0).toDouble(),
      runRate: (json['runRate'] ?? 0).toDouble(),
      isCompleted: json['isCompleted'] ?? false,
      isDeclared: json['isDeclared'] ?? false,
      batting: (json['batting'] as List? ?? [])
          .map((b) => BatsmanApiModel.fromJson(b as Map<String, dynamic>))
          .toList(),
      bowling: (json['bowling'] as List? ?? [])
          .map((b) => BowlerApiModel.fromJson(b as Map<String, dynamic>))
          .toList(),
      extras: ExtrasApiModel.fromJson(
        json['extras'] as Map<String, dynamic>? ?? {},
      ),
      fallOfWickets: (json['fallOfWickets'] as List? ?? [])
          .map((f) => FowApiModel.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  InningsEntity toEntity() {
    return InningsEntity(
      inningsNumber: inningsNumber,
      battingTeam: battingTeam,
      bowlingTeam: bowlingTeam,
      totalRuns: totalRuns,
      totalWickets: totalWickets,
      totalOvers: totalOvers,
      runRate: runRate,
      isCompleted: isCompleted,
      isDeclared: isDeclared,
      batting: batting.map((b) => b.toEntity()).toList(),
      bowling: bowling.map((b) => b.toEntity()).toList(),
      extras: extras.toEntity(),
      fallOfWickets: fallOfWickets.map((f) => f.toEntity()).toList(),
    );
  }
}

class LiveBatsmanApiModel {
  final String name;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double strikeRate;

  LiveBatsmanApiModel({
    required this.name,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
  });

  factory LiveBatsmanApiModel.fromJson(Map<String, dynamic> json) {
    return LiveBatsmanApiModel(
      name: json['name'] ?? '',
      runs: json['runs'] ?? 0,
      balls: json['balls'] ?? 0,
      fours: json['fours'] ?? 0,
      sixes: json['sixes'] ?? 0,
      strikeRate: (json['strikeRate'] ?? 0).toDouble(),
    );
  }

  LiveBatsmanEntity toEntity() {
    return LiveBatsmanEntity(
      name: name,
      runs: runs,
      balls: balls,
      fours: fours,
      sixes: sixes,
      strikeRate: strikeRate,
    );
  }
}

class LiveBowlerApiModel {
  final String name;
  final double overs;
  final int runs;
  final int wickets;
  final double economy;

  LiveBowlerApiModel({
    required this.name,
    required this.overs,
    required this.runs,
    required this.wickets,
    required this.economy,
  });

  factory LiveBowlerApiModel.fromJson(Map<String, dynamic> json) {
    return LiveBowlerApiModel(
      name: json['name'] ?? '',
      overs: (json['overs'] ?? 0).toDouble(),
      runs: json['runs'] ?? 0,
      wickets: json['wickets'] ?? 0,
      economy: (json['economy'] ?? 0).toDouble(),
    );
  }

  LiveBowlerEntity toEntity() {
    return LiveBowlerEntity(
      name: name,
      overs: overs,
      runs: runs,
      wickets: wickets,
      economy: economy,
    );
  }
}

class LiveScoreApiModel {
  final int currentInnings;
  final String battingTeam;
  final String bowlingTeam;
  final String score;
  final String runRate;
  final String? requiredRunRate;
  final int? target;
  final String? situation;
  final LiveBatsmanApiModel batsmanOne;
  final LiveBatsmanApiModel batsmanTwo;
  final LiveBowlerApiModel currentBowler;
  final List<String> recentBalls;
  final String? lastWicket;
  final String? commentary;

  LiveScoreApiModel({
    required this.currentInnings,
    required this.battingTeam,
    required this.bowlingTeam,
    required this.score,
    required this.runRate,
    this.requiredRunRate,
    this.target,
    this.situation,
    required this.batsmanOne,
    required this.batsmanTwo,
    required this.currentBowler,
    required this.recentBalls,
    this.lastWicket,
    this.commentary,
  });

  factory LiveScoreApiModel.fromJson(Map<String, dynamic> json) {
    return LiveScoreApiModel(
      currentInnings: json['currentInnings'] ?? 1,
      battingTeam: json['battingTeam'] ?? '',
      bowlingTeam: json['bowlingTeam'] ?? '',
      score: json['score'] ?? '0/0',
      runRate: json['runRate']?.toString() ?? '0.00',
      requiredRunRate: json['requiredRunRate']?.toString(),
      target: json['target'],
      situation: json['situation'],
      batsmanOne: LiveBatsmanApiModel.fromJson(
        json['batsmanOne'] as Map<String, dynamic>? ?? {},
      ),
      batsmanTwo: LiveBatsmanApiModel.fromJson(
        json['batsmanTwo'] as Map<String, dynamic>? ?? {},
      ),
      currentBowler: LiveBowlerApiModel.fromJson(
        json['currentBowler'] as Map<String, dynamic>? ?? {},
      ),
      recentBalls: List<String>.from(json['recentBalls'] ?? []),
      lastWicket: json['lastWicket'],
      commentary: json['commentary'],
    );
  }

  LiveScoreEntity toEntity() {
    return LiveScoreEntity(
      currentInnings: currentInnings,
      battingTeam: battingTeam,
      bowlingTeam: bowlingTeam,
      score: score,
      runRate: runRate,
      requiredRunRate: requiredRunRate,
      target: target,
      situation: situation,
      batsmanOne: batsmanOne.toEntity(),
      batsmanTwo: batsmanTwo.toEntity(),
      currentBowler: currentBowler.toEntity(),
      recentBalls: recentBalls,
      lastWicket: lastWicket,
      commentary: commentary,
    );
  }
}

class ScorecardApiModel {
  final String matchId;
  final List<InningsApiModel> innings;
  final LiveScoreApiModel? liveScore;

  ScorecardApiModel({
    required this.matchId,
    required this.innings,
    this.liveScore,
  });

  factory ScorecardApiModel.fromJson(Map<String, dynamic> json) {
    return ScorecardApiModel(
      matchId: json['matchId'] ?? '',
      innings: (json['innings'] as List? ?? [])
          .map((i) => InningsApiModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      liveScore: json['liveScore'] != null
          ? LiveScoreApiModel.fromJson(
              json['liveScore'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  ScorecardEntity toEntity() {
    return ScorecardEntity(
      matchId: matchId,
      innings: innings.map((i) => i.toEntity()).toList(),
      liveScore: liveScore?.toEntity(),
    );
  }
}
