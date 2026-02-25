import 'package:flutter/material.dart';
import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';

const _formatColors = {
  'T20': Color(0xFFa855f7),
  'ODI': Color(0xFFf97316),
  'TEST': Color(0xFFef4444),
  'T10': Color(0xFFec4899),
};

class MatchCard extends StatelessWidget {
  final MatchEntity match;
  final VoidCallback onTap;

  const MatchCard({super.key, required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fmtColor = _formatColors[match.format] ?? const Color(0xFF6366f1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1e2433) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: match.isLive
                ? const Color(0xFF22c55e).withOpacity(0.5)
                : isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Live green top bar
            if (match.isLive)
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF22c55e), Color(0xFF10b981)],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Series + format badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${match.seriesName} • ${match.matchNumber}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (match.isLive) _LivePill(),
                      const SizedBox(width: 6),
                      _FormatBadge(format: match.format, color: fmtColor),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Teams
                  Row(
                    children: [
                      Expanded(
                        child: _TeamRow(
                          team: match.team1,
                          gradientColors: const [
                            Color(0xFF3b82f6),
                            Color(0xFF6366f1),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'vs',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _TeamRow(
                          team: match.team2,
                          gradientColors: const [
                            Color(0xFFf97316),
                            Color(0xFFef4444),
                          ],
                          rightAlign: true,
                        ),
                      ),
                    ],
                  ),

                  // Live status / result
                  if (match.isLive && match.liveStatus != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22c55e).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        match.liveStatus!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF16a34a),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else if (match.isCompleted && match.result != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      match.result!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 10),

                  // Footer: venue + date/status
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 11,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${match.venue.city}, ${match.venue.country}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusBadge(match: match),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final TeamEntity team;
  final List<Color> gradientColors;
  final bool rightAlign;

  const _TeamRow({
    required this.team,
    required this.gradientColors,
    this.rightAlign = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          team.shortName.length >= 2
              ? team.shortName.substring(0, 2)
              : team.shortName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final name = Expanded(
      child: Text(
        team.name,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        overflow: TextOverflow.ellipsis,
        textAlign: rightAlign ? TextAlign.right : TextAlign.left,
      ),
    );

    return Row(
      children: rightAlign
          ? [name, const SizedBox(width: 8), avatar]
          : [avatar, const SizedBox(width: 8), name],
    );
  }
}

class _LivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF22c55e).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF22c55e).withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF22c55e),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Color(0xFF22c55e),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatBadge extends StatelessWidget {
  final String format;
  final Color color;

  const _FormatBadge({required this.format, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        format,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MatchEntity match;

  const _StatusBadge({required this.match});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = match.isLive
        ? ('LIVE', const Color(0xFFdcfce7), const Color(0xFF16a34a))
        : match.isUpcoming
        ? ('UPCOMING', const Color(0xFFdbeafe), const Color(0xFF2563eb))
        : match.isCompleted
        ? ('DONE', const Color(0xFFf3f4f6), const Color(0xFF6b7280))
        : (
            match.status.toUpperCase(),
            const Color(0xFFf3f4f6),
            const Color(0xFF6b7280),
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}
