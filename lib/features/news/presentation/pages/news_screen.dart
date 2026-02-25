import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/dashboard/presentation/widgets/softbuzz_app_bar.dart';
import 'package:softbuzz_app/features/news/presentation/view_model/news_viewmodel.dart';
import 'package:softbuzz_app/features/news/presentation/widgets/news_card.dart';
import 'package:softbuzz_app/features/news/presentation/pages/news_detail_page.dart';

const _categories = [
  ('All', null),
  ('Top Stories', 'top_stories'),
  ('International', 'international'),
  ('IPL', 'ipl'),
  ('NPL', 'npl'),
  ('Domestic', 'domestic'),
];

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsListViewModelProvider.notifier).getNews();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsListViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F1419)
          : const Color(0xFFF8F9FE),
      appBar: SoftBuzzAppBar(
        title: 'News',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, size: 22),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: isDark ? const Color(0xFF0F1419) : Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              indicatorColor: const Color(0xFF22c55e),
              indicatorWeight: 2.5,
              labelColor: const Color(0xFF22c55e),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              onTap: (i) => ref
                  .read(newsListViewModelProvider.notifier)
                  .getNews(category: _categories[i].$2),
              tabs: _categories.map((c) => Tab(text: c.$1)).toList(),
            ),
          ),
          Container(
            height: 1,
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.grey.shade100,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((_) => _Body(state: state)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final NewsListState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (state.status) {
      NewsLoadStatus.loading => const Center(
        child: CircularProgressIndicator(color: Color(0xFF22c55e)),
      ),
      NewsLoadStatus.error => _ErrorView(
        message: state.errorMessage ?? 'Something went wrong',
        onRetry: () => ref
            .read(newsListViewModelProvider.notifier)
            .getNews(category: state.selectedCategory),
      ),
      NewsLoadStatus.success when state.articles.isEmpty => const _EmptyView(),
      _ => RefreshIndicator(
        color: const Color(0xFF22c55e),
        onRefresh: () => ref
            .read(newsListViewModelProvider.notifier)
            .getNews(category: state.selectedCategory),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.articles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) {
            final article = state.articles[i];
            return NewsCard(
              article: article,
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => NewsDetailPage(slug: article.slug),
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
          Text('📰', style: TextStyle(fontSize: 52)),
          SizedBox(height: 12),
          Text(
            'No articles found',
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
