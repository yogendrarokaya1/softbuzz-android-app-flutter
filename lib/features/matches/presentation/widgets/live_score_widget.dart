import 'package:flutter/material.dart';
import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';

class LiveScoreWidget extends StatelessWidget {
  final LiveScoreEntity liveScore;

  const LiveScoreWidget({super.key, required this.liveScore});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    liveScore.battingTeam,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  if (liveScore.target != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Target ${liveScore.target}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                liveScore.score,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _RateChip(label: 'CRR', value: liveScore.runRate),
                  if (liveScore.requiredRunRate != null) ...[
                    const SizedBox(width: 8),
                    _RateChip(label: 'RRR', value: liveScore.requiredRunRate!),
                  ],
                ],
              ),
              if (liveScore.situation != null) ...[
                const SizedBox(height: 10),
                Text(
                  liveScore.situation!,
                  style: const TextStyle(
                    color: Color(0xFF22c55e),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Recent balls
        if (liveScore.recentBalls.isNotEmpty) ...[
          _Label('Recent'),
          const SizedBox(height: 8),
          Row(
            children: liveScore.recentBalls
                .map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _BallChip(ball: b),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Batting
        _Label('Batting'),
        const SizedBox(height: 8),
        _LiveBatsmanRow(batsman: liveScore.batsmanOne, isStriker: true),
        const SizedBox(height: 6),
        _LiveBatsmanRow(batsman: liveScore.batsmanTwo, isStriker: false),
        const SizedBox(height: 16),

        // Bowling
        _Label('Bowling'),
        const SizedBox(height: 8),
        _LiveBowlerRow(bowler: liveScore.currentBowler, isDark: isDark),

        // Last wicket
        if (liveScore.lastWicket != null) ...[
          const SizedBox(height: 16),
          _Label('Last Wicket'),
          const SizedBox(height: 8),
          Text(
            liveScore.lastWicket!,
            style: const TextStyle(fontSize: 13, color: Color(0xFFef4444)),
          ),
        ],

        // Commentary
        if (liveScore.commentary != null) ...[
          const SizedBox(height: 16),
          _Label('Commentary'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.shade200,
              ),
            ),
            child: Text(
              liveScore.commentary!,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFF22c55e),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _RateChip extends StatelessWidget {
  final String label;
  final String value;
  const _RateChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BallChip extends StatelessWidget {
  final String ball;
  const _BallChip({required this.ball});

  Color get _color {
    return switch (ball) {
      'W' => const Color(0xFFef4444),
      '4' => const Color(0xFF3b82f6),
      '6' => const Color(0xFFa855f7),
      '0' => Colors.grey,
      _ => const Color(0xFF22c55e),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          ball,
          style: TextStyle(
            color: _color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _LiveBatsmanRow extends StatelessWidget {
  final LiveBatsmanEntity batsman;
  final bool isStriker;
  const _LiveBatsmanRow({required this.batsman, required this.isStriker});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStriker
              ? const Color(0xFF22c55e).withOpacity(0.4)
              : isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          if (isStriker)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(
                Icons.sports_cricket,
                size: 13,
                color: Color(0xFF22c55e),
              ),
            ),
          Expanded(
            child: Text(
              batsman.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          _MiniStat(label: 'R', value: '${batsman.runs}'),
          _MiniStat(label: 'B', value: '${batsman.balls}'),
          _MiniStat(label: '4s', value: '${batsman.fours}'),
          _MiniStat(label: '6s', value: '${batsman.sixes}'),
          _MiniStat(label: 'SR', value: batsman.strikeRate.toStringAsFixed(1)),
        ],
      ),
    );
  }
}

class _LiveBowlerRow extends StatelessWidget {
  final LiveBowlerEntity bowler;
  final bool isDark;
  const _LiveBowlerRow({required this.bowler, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              bowler.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          _MiniStat(label: 'O', value: bowler.overs.toStringAsFixed(1)),
          _MiniStat(label: 'R', value: '${bowler.runs}'),
          _MiniStat(label: 'W', value: '${bowler.wickets}'),
          _MiniStat(label: 'Eco', value: bowler.economy.toStringAsFixed(2)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
