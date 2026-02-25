class BatsmanEntity {
  final String name;
  final String dismissal;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double strikeRate;
  final bool isNotOut;

  const BatsmanEntity({
    required this.name,
    required this.dismissal,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.isNotOut,
  });
}

class BowlerEntity {
  final String name;
  final double overs;
  final int maidens;
  final int runs;
  final int wickets;
  final double economy;
  final int noBalls;
  final int wides;

  const BowlerEntity({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
    required this.noBalls,
    required this.wides,
  });
}

class ExtrasEntity {
  final int wides;
  final int noBalls;
  final int byes;
  final int legByes;
  final int penalty;
  final int total;

  const ExtrasEntity({
    required this.wides,
    required this.noBalls,
    required this.byes,
    required this.legByes,
    required this.penalty,
    required this.total,
  });
}

class FowEntity {
  final int wicketNumber;
  final int runs;
  final double overs;
  final String batsmanName;

  const FowEntity({
    required this.wicketNumber,
    required this.runs,
    required this.overs,
    required this.batsmanName,
  });
}

class InningsEntity {
  final int inningsNumber;
  final String battingTeam;
  final String bowlingTeam;
  final int totalRuns;
  final int totalWickets;
  final double totalOvers;
  final double runRate;
  final bool isCompleted;
  final bool isDeclared;
  final List<BatsmanEntity> batting;
  final List<BowlerEntity> bowling;
  final ExtrasEntity extras;
  final List<FowEntity> fallOfWickets;

  const InningsEntity({
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

  String get scoreText =>
      '$totalRuns/$totalWickets (${totalOvers.toStringAsFixed(1)} ov)';
}

class LiveBatsmanEntity {
  final String name;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double strikeRate;

  const LiveBatsmanEntity({
    required this.name,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
  });
}

class LiveBowlerEntity {
  final String name;
  final double overs;
  final int runs;
  final int wickets;
  final double economy;

  const LiveBowlerEntity({
    required this.name,
    required this.overs,
    required this.runs,
    required this.wickets,
    required this.economy,
  });
}

class LiveScoreEntity {
  final int currentInnings;
  final String battingTeam;
  final String bowlingTeam;
  final String score;
  final String runRate;
  final String? requiredRunRate;
  final int? target;
  final String? situation;
  final LiveBatsmanEntity batsmanOne;
  final LiveBatsmanEntity batsmanTwo;
  final LiveBowlerEntity currentBowler;
  final List<String> recentBalls;
  final String? lastWicket;
  final String? commentary;

  const LiveScoreEntity({
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
}

class ScorecardEntity {
  final String matchId;
  final List<InningsEntity> innings;
  final LiveScoreEntity? liveScore;

  const ScorecardEntity({
    required this.matchId,
    required this.innings,
    this.liveScore,
  });
}
