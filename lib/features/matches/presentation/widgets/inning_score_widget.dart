import 'package:flutter/material.dart';
import 'package:softbuzz_app/features/matches/domain/entities/scorecard_entity.dart';

class InningsScorecardWidget extends StatefulWidget {
  final List<InningsEntity> innings;
  const InningsScorecardWidget({super.key, required this.innings});

  @override
  State<InningsScorecardWidget> createState() => _InningsScorecardWidgetState();
}

class _InningsScorecardWidgetState extends State<InningsScorecardWidget> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final inn = widget.innings[_selected];

    return Column(
      children: [
        // Innings selector tabs
        if (widget.innings.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: List.generate(widget.innings.length, (i) {
                final sel = i == _selected;
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: i < widget.innings.length - 1 ? 8 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: sel
                            ? Theme.of(context).colorScheme.primary
                            : isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.innings[i].battingTeam,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: sel ? Colors.white : null,
                            ),
                          ),
                          Text(
                            widget.innings[i].scoreText,
                            style: TextStyle(
                              fontSize: 10,
                              color: sel
                                  ? Colors.white70
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _InnHeader(innings: inn),
              const SizedBox(height: 16),
              _SectionLabel('Batting'),
              const SizedBox(height: 8),
              _BattingTable(batting: inn.batting),
              const SizedBox(height: 6),
              _ExtrasRow(extras: inn.extras),
              const SizedBox(height: 16),
              _SectionLabel('Bowling'),
              const SizedBox(height: 8),
              _BowlingTable(bowling: inn.bowling),
              if (inn.fallOfWickets.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionLabel('Fall of Wickets'),
                const SizedBox(height: 8),
                _FowWrap(fow: inn.fallOfWickets),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InnHeader extends StatelessWidget {
  final InningsEntity innings;
  const _InnHeader({required this.innings});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e2433) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                innings.battingTeam,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                'Innings ${innings.inningsNumber}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const Spacer(),
          Text(
            innings.scoreText,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'RR: ${innings.runRate.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              if (innings.isDeclared)
                const Text(
                  'Declared',
                  style: TextStyle(color: Color(0xFFf97316), fontSize: 10),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
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

// ── Batting Table ─────────────────────────────────────────────────────────────

class _BattingTable extends StatelessWidget {
  final List<BatsmanEntity> batting;
  const _BattingTable({required this.batting});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e2433) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _TableHead(cols: const ['Batsman', 'R', 'B', '4s', '6s', 'SR']),
          ...batting.asMap().entries.map(
            (e) => _BatsmanRow(b: e.value, isEven: e.key.isEven),
          ),
        ],
      ),
    );
  }
}

class _BatsmanRow extends StatelessWidget {
  final BatsmanEntity b;
  final bool isEven;
  const _BatsmanRow({required this.b, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isEven
          ? null
          : isDark
          ? Colors.white.withOpacity(0.02)
          : Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        b.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (b.isNotOut)
                      const Text(
                        ' *',
                        style: TextStyle(
                          color: Color(0xFF22c55e),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                Text(
                  b.dismissal,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          _Cell('${b.runs}', bold: true),
          _Cell('${b.balls}'),
          _Cell('${b.fours}'),
          _Cell('${b.sixes}'),
          _Cell(b.strikeRate.toStringAsFixed(1)),
        ],
      ),
    );
  }
}

// ── Bowling Table ─────────────────────────────────────────────────────────────

class _BowlingTable extends StatelessWidget {
  final List<BowlerEntity> bowling;
  const _BowlingTable({required this.bowling});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e2433) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _TableHead(cols: const ['Bowler', 'O', 'M', 'R', 'W', 'Eco']),
          ...bowling.asMap().entries.map(
            (e) => Container(
              color: e.key.isOdd
                  ? isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.grey.shade50
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.value.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _Cell(e.value.overs.toStringAsFixed(1)),
                  _Cell('${e.value.maidens}'),
                  _Cell('${e.value.runs}'),
                  _Cell('${e.value.wickets}', bold: true),
                  _Cell(e.value.economy.toStringAsFixed(2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  final List<String> cols;
  const _TableHead({required this.cols});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: cols.asMap().entries.map((e) {
          if (e.key == 0) {
            return Expanded(
              flex: 3,
              child: Text(
                e.value,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.3,
                ),
              ),
            );
          }
          return _Cell(
            e.value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  final TextStyle? style;
  const _Cell(this.text, {this.bold = false, this.style});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style:
            style ??
            TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
      ),
    );
  }
}

class _ExtrasRow extends StatelessWidget {
  final ExtrasEntity extras;
  const _ExtrasRow({required this.extras});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Extras',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'b ${extras.byes}, lb ${extras.legByes}, '
              'w ${extras.wides}, nb ${extras.noBalls}  '
              '(${extras.total})',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _FowWrap extends StatelessWidget {
  final List<FowEntity> fow;
  const _FowWrap({required this.fow});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: fow
          .map(
            (f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${f.wicketNumber}-${f.runs} '
                '(${f.batsmanName}, ${f.overs})',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          )
          .toList(),
    );
  }
}
