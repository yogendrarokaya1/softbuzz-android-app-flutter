import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/news/domain/entities/news_entity.dart';
import 'package:softbuzz_app/features/news/presentation/view_model/news_viewmodel.dart';
import 'package:softbuzz_app/features/news/presentation/widgets/category_badge.dart';

class NewsDetailPage extends ConsumerStatefulWidget {
  final String slug;
  const NewsDetailPage({super.key, required this.slug});

  @override
  ConsumerState<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends ConsumerState<NewsDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsDetailViewModelProvider.notifier).loadArticle(widget.slug);
    });
  }

  @override
  void dispose() {
    ref.read(newsDetailViewModelProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsDetailViewModelProvider);

    return switch (state.status) {
      NewsLoadStatus.loading => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF22c55e)),
        ),
      ),
      NewsLoadStatus.error => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'Failed to load article',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
      _ when state.article != null => _ArticleView(article: state.article!),
      _ => const Scaffold(body: SizedBox()),
    };
  }
}

class _ArticleView extends StatelessWidget {
  final NewsEntity article;
  const _ArticleView({required this.article});

  String _timeAgo(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paragraphs = article.content
        .split(RegExp(r'\n\n+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0f1117)
          : const Color(0xFFf8fafc),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with cover image
          SliverAppBar(
            pinned: true,
            expandedHeight: article.coverImage.isNotEmpty ? 240 : 0,
            backgroundColor: isDark ? const Color(0xFF0f1117) : Colors.white,
            flexibleSpace: article.coverImage.isNotEmpty
                ? FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          article.coverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: isDark
                                ? const Color(0xFF1e293b)
                                : Colors.grey.shade200,
                          ),
                        ),
                        // Gradient overlay so back button is visible
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),

          // ── Article content
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? const Color(0xFF0f1117) : const Color(0xFFf8fafc),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Breaking
                  Row(
                    children: [
                      CategoryBadge(category: article.category, large: true),
                      if (article.isBreaking) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFef4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '● BREAKING',
                            style: TextStyle(
                              color: Color(0xFFef4444),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Summary with left accent border
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: categoryColor(article.category),
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      article.summary,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFF22c55e),
                        child: Text(
                          article.author.isNotEmpty
                              ? article.author[0].toUpperCase()
                              : 'S',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        article.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '  ·  ',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        _timeAgo(article.displayDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        '  ·  ',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Icon(
                        Icons.access_time_outlined,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${article.readTime} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 20),

                  // Article body paragraphs
                  ...paragraphs.map(
                    (para) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        para,
                        style: const TextStyle(fontSize: 15, height: 1.8),
                      ),
                    ),
                  ),

                  // Tags
                  if (article.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.07)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
