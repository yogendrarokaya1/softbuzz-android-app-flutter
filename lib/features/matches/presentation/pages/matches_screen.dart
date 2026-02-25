import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/matches/presentation/pages/matches_detail_page.dart';
import 'package:softbuzz_app/features/matches/presentation/state/match_state.dart';
import 'package:softbuzz_app/features/matches/presentation/view_model/match_viewmodel.dart';
import 'package:softbuzz_app/features/matches/presentation/widgets/match_card.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    ('All', null),
    ('Live', 'live'),
    ('Upcoming', 'upcoming'),
    ('Recent', 'completed'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchListViewModelProvider.notifier).getMatches();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchListViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0f1117)
          : const Color(0xFFf8fafc),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0f1117) : Colors.white,
        elevation: 0,
        title: const Text(
          'Matches',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          onTap: (i) => ref
              .read(matchListViewModelProvider.notifier)
              .getMatches(status: _tabs[i].$2),
          indicatorColor: const Color(0xFF22c55e),
          labelColor: const Color(0xFF22c55e),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: _tabs
              .map(
                (t) => Tab(
                  child: Row(
                    children: [
                      if (t.$2 == 'live') ...[
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22c55e),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Text(t.$1),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // All tabs share the same state — switching tab triggers fetch
        children: _tabs.map((_) => _Body(state: state)).toList(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final MatchListState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (state.status) {
      MatchLoadStatus.loading => const Center(
        child: CircularProgressIndicator(color: Color(0xFF22c55e)),
      ),
      MatchLoadStatus.error => _ErrorView(
        message: state.errorMessage ?? 'Something went wrong',
        onRetry: () =>
            ref.read(matchListViewModelProvider.notifier).getMatches(),
      ),
      MatchLoadStatus.success when state.matches.isEmpty => const _EmptyView(),
      _ => RefreshIndicator(
        color: const Color(0xFF22c55e),
        onRefresh: () =>
            ref.read(matchListViewModelProvider.notifier).getMatches(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.matches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) {
            final match = state.matches[i];
            return MatchCard(
              match: match,
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => MatchDetailPage(matchId: match.id),
                ),
              ),
            );
          },
        ),
      ),
    };
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🏏', style: TextStyle(fontSize: 52)),
          SizedBox(height: 12),
          Text(
            'No matches found',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 52, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22c55e),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
