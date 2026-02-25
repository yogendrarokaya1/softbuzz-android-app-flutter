import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state.status) {
      NewsLoadStatus.loading => Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F1419)
            : const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
          elevation: 0,
          leading: _BackButton(isDark: isDark),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF22c55e)),
        ),
      ),
      NewsLoadStatus.error => Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F1419)
            : const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
          elevation: 0,
          leading: _BackButton(isDark: isDark),
        ),
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

class _BackButton extends StatelessWidget {
  final bool isDark;
  const _BackButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: isDark ? Colors.white : const Color(0xFF0F1419),
          ),
        ),
      ),
    );
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
          ? const Color(0xFF0F1419)
          : const Color(0xFFF8F9FE),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: article.coverImage.isNotEmpty ? 240 : 0,
            backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
            systemOverlayStyle: article.coverImage.isNotEmpty
                ? SystemUiOverlayStyle.light
                : isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: article.coverImage.isNotEmpty
                        ? Colors.white.withOpacity(0.15)
                        : isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: article.coverImage.isNotEmpty
                        ? Colors.white
                        : isDark
                        ? Colors.white
                        : const Color(0xFF0F1419),
                  ),
                ),
              ),
            ),
            title: article.coverImage.isEmpty
                ? Text(
                    'Article',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFE8EAED)
                          : const Color(0xFF0F1419),
                    ),
                  )
                : null,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.shade100,
              ),
            ),
          ),

          // ── Article Content ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
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
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    article.title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      color: isDark
                          ? const Color(0xFFE8EAED)
                          : const Color(0xFF0F1419),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Summary
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
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFB4B8BB)
                            : const Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta
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
                      Expanded(
                        child: Text(
                          article.author,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFFE8EAED)
                                : const Color(0xFF0F1419),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _timeAgo(article.displayDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time_outlined,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${article.readTime} min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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

                  // Body paragraphs
                  ...paragraphs.map(
                    (para) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        para,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          height: 1.8,
                          color: isDark
                              ? const Color(0xFFE8EAED)
                              : const Color(0xFF2D3142),
                        ),
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
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFFB4B8BB)
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
