import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';
import 'package:softbuzz_app/features/matches/presentation/state/match_state.dart';
import 'package:softbuzz_app/features/matches/presentation/view_model/match_viewmodel.dart';
import 'package:softbuzz_app/features/matches/presentation/widgets/inning_score_widget.dart';
import 'package:softbuzz_app/features/matches/presentation/widgets/live_score_widget.dart';

class MatchDetailPage extends ConsumerStatefulWidget {
  final String matchId;
  const MatchDetailPage({super.key, required this.matchId});

  @override
  ConsumerState<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends ConsumerState<MatchDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchDetailViewModelProvider.notifier).loadMatch(widget.matchId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    ref.read(matchDetailViewModelProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchDetailViewModelProvider);

    if (state.status == MatchLoadStatus.loading && state.match == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF22c55e)),
        ),
      );
    }

    if (state.status == MatchLoadStatus.error && state.match == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(state.errorMessage ?? 'Error loading match')),
      );
    }

    if (state.match == null) return const Scaffold(body: SizedBox());

    return _MatchDetailView(state: state, tabController: _tabController);
  }
}

class _MatchDetailView extends StatelessWidget {
  final MatchDetailState state;
  final TabController tabController;

  const _MatchDetailView({required this.state, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final match = state.match!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0f1117)
          : const Color(0xFFf8fafc),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: isDark ? const Color(0xFF0f1117) : Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _MatchHeader(match: match),
            ),
            bottom: TabBar(
              controller: tabController,
              indicatorColor: const Color(0xFF22c55e),
              labelColor: const Color(0xFF22c55e),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: 'Live Score'),
                Tab(text: 'Scorecard'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            // ── Live Score Tab
            match.isLive && state.scorecard?.liveScore != null
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: LiveScoreWidget(
                      liveScore: state.scorecard!.liveScore!,
                    ),
                  )
                : _NoLiveScore(match: match),

            // ── Scorecard Tab
            state.scorecardStatus == MatchLoadStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF22c55e)),
                  )
                : state.scorecard != null && state.scorecard!.innings.isNotEmpty
                ? InningsScorecardWidget(innings: state.scorecard!.innings)
                : const Center(
                    child: Text(
                      'No scorecard available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ── Match Header ──────────────────────────────────────────────────────────────

class _MatchHeader extends StatelessWidget {
  final MatchEntity match;
  const _MatchHeader({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Series name
          Text(
            match.seriesName,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),

          // Teams row
          Row(
            children: [
              Expanded(
                child: _HeaderTeam(
                  team: match.team1,
                  align: CrossAxisAlignment.start,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      match.format,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (match.isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22c55e).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF22c55e).withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 5, color: Color(0xFF22c55e)),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Color(0xFF22c55e),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Expanded(
                child: _HeaderTeam(
                  team: match.team2,
                  align: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '📍 ${match.venue.stadiumName}, ${match.venue.city}',
            style: const TextStyle(color: Colors.white30, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _HeaderTeam extends StatelessWidget {
  final TeamEntity team;
  final CrossAxisAlignment align;
  const _HeaderTeam({required this.team, required this.align});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white12,
          child: Text(
            team.shortName.length >= 2
                ? team.shortName.substring(0, 2)
                : team.shortName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          team.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _NoLiveScore extends StatelessWidget {
  final MatchEntity match;
  const _NoLiveScore({required this.match});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            match.isUpcoming ? '⏳' : '🏆',
            style: const TextStyle(fontSize: 52),
          ),
          const SizedBox(height: 12),
          Text(
            match.isUpcoming
                ? 'Match hasn\'t started yet'
                : match.result ?? 'Match completed',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
