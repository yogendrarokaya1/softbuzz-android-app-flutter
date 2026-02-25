import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/dashboard/presentation/widgets/softbuzz_app_bar.dart';
import 'package:softbuzz_app/features/matches/domain/entities/match_entity.dart';
import 'package:softbuzz_app/features/matches/domain/usecases/match_usecases.dart';
import 'package:softbuzz_app/features/matches/presentation/pages/matches_detail_page.dart';
import 'package:softbuzz_app/features/matches/presentation/widgets/match_card.dart';
import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';
import 'package:softbuzz_app/features/news/domain/usecases/news_usecases.dart';
import 'package:softbuzz_app/features/news/presentation/pages/news_detail_page.dart';
import 'package:softbuzz_app/features/news/presentation/pages/news_screen.dart';
import 'package:softbuzz_app/features/news/presentation/widgets/news_card.dart';
import 'package:softbuzz_app/features/matches/presentation/pages/matches_screen.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final homeMatchesProvider = FutureProvider<HomeMatchesEntity>((ref) async {
  final result = await ref.read(getHomeMatchesUsecaseProvider)();
  return result.fold(
    (_) => const HomeMatchesEntity(live: [], upcoming: [], featured: []),
    (data) => data,
  );
});

final homeLatestNewsProvider = FutureProvider<List<NewsEntity>>((ref) async {
  final result = await ref.read(getLatestNewsUsecaseProvider)(6);
  return result.fold((_) => [], (n) => n);
});

final homeBreakingNewsProvider = FutureProvider<List<NewsEntity>>((ref) async {
  final result = await ref.read(getBreakingNewsUsecaseProvider)();
  return result.fold((_) => [], (n) => n);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeMatchesProvider);
    final newsAsync = ref.watch(homeLatestNewsProvider);
    final breakingAsync = ref.watch(homeBreakingNewsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F1419)
          : const Color(0xFFF8F9FE),
      appBar: SoftBuzzHomeAppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, size: 22),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, size: 22),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF22c55e),
        onRefresh: () async {
          ref.invalidate(homeMatchesProvider);
          ref.invalidate(homeLatestNewsProvider);
          ref.invalidate(homeBreakingNewsProvider);
        },
        child: CustomScrollView(
          slivers: [
            // ── Breaking Ticker ─────────────────────────────────────
            breakingAsync.when(
              data: (breaking) => breaking.isEmpty
                  ? const SliverToBoxAdapter(child: SizedBox.shrink())
                  : SliverToBoxAdapter(
                      child: _BreakingTicker(breaking: breaking),
                    ),
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // ── Hero Banner ─────────────────────────────────────────
            homeAsync.when(
              data: (home) => SliverToBoxAdapter(
                child: _HeroBanner(
                  liveCount: home.live.length,
                  upcomingCount: home.upcoming.length,
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: _HeroBanner(liveCount: 0, upcomingCount: 0),
              ),
              error: (_, __) => const SliverToBoxAdapter(
                child: _HeroBanner(liveCount: 0, upcomingCount: 0),
              ),
            ),

            // ── Live Matches ────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: '🟢  Live Matches',
                onSeeAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MatchesScreen()),
                ),
              ),
            ),
            homeAsync.when(
              data: (home) => home.live.isEmpty
                  ? const SliverToBoxAdapter(
                      child: _EmptySection(label: 'No live matches right now'),
                    )
                  : _MatchListSliver(matches: home.live),
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(color: Color(0xFF22c55e)),
                  ),
                ),
              ),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // ── Upcoming ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: '📅  Upcoming',
                onSeeAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MatchesScreen()),
                ),
              ),
            ),
            homeAsync.when(
              data: (home) => home.upcoming.isEmpty
                  ? const SliverToBoxAdapter(
                      child: _EmptySection(label: 'No upcoming matches'),
                    )
                  : _MatchListSliver(matches: home.upcoming),
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // ── Latest News ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: '📰  Latest News',
                onSeeAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewsScreen()),
                ),
              ),
            ),
            newsAsync.when(
              data: (articles) => articles.isEmpty
                  ? const SliverToBoxAdapter(
                      child: _EmptySection(label: 'No news available'),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: NewsCard(
                              article: articles[i],
                              onTap: () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NewsDetailPage(slug: articles[i].slug),
                                ),
                              ),
                            ),
                          ),
                          childCount: articles.length,
                        ),
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(color: Color(0xFF22c55e)),
                  ),
                ),
              ),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _MatchListSliver extends StatelessWidget {
  final List<MatchEntity> matches;
  const _MatchListSliver({required this.matches});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MatchCard(
              match: matches[i],
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => MatchDetailPage(matchId: matches[i].id),
                ),
              ),
            ),
          ),
          childCount: matches.length,
        ),
      ),
    );
  }
}

class _BreakingTicker extends StatelessWidget {
  final List<NewsEntity> breaking;
  const _BreakingTicker({required this.breaking});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFdc2626),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'BREAKING',
              style: TextStyle(
                color: Color(0xFFdc2626),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              breaking.map((b) => b.title).join('  •  '),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final int liveCount;
  final int upcomingCount;
  const _HeroBanner({
    required this.liveCount,
    required this.upcomingCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0f172a), Color(0xFF1e3a5f)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (liveCount > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22c55e).withOpacity(0.15),
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
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22c55e),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$liveCount Live Match${liveCount > 1 ? 'es' : ''}',
                          style: const TextStyle(
                            color: Color(0xFF22c55e),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Text(
                  'Your Cricket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [Color(0xFF22c55e), Color(0xFF10b981)],
                  ).createShader(b),
                  child: const Text(
                    'Command Centre',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Live scores, schedules & news',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              _StatBox(
                value: liveCount,
                label: 'Live',
                color: const Color(0xFF22c55e),
              ),
              const SizedBox(height: 8),
              _StatBox(
                value: upcomingCount,
                label: 'Soon',
                color: const Color(0xFF3b82f6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFE8EAED) : const Color(0xFF0F1419),
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all →',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF3b82f6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String label;
  const _EmptySection({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      ),
    );
  }
}
