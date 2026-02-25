import 'package:flutter/material.dart';
import 'package:softbuzz_app/features/dashboard/presentation/pages/bottomnav/home_screen.dart';
import 'package:softbuzz_app/features/dashboard/presentation/pages/bottomnav/matches.dart';
import 'package:softbuzz_app/features/dashboard/presentation/pages/bottomnav/news.dart';
import 'package:softbuzz_app/features/dashboard/presentation/pages/bottomnav/videos.dart';
import 'package:softbuzz_app/features/dashboard/presentation/pages/bottomnav/more.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static final _pages = [
    const HomeScreen(),
    const MatchesScreen(),
    const NewsScreen(),
    const VideosScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: isDark ? const Color(0xFF0f1117) : Colors.white,
        indicatorColor: const Color(0xFF22c55e).withOpacity(0.15),
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF22c55e)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_cricket_outlined),
            selectedIcon: Icon(Icons.sports_cricket, color: Color(0xFF22c55e)),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(
              Icons.newspaper_rounded,
              color: Color(0xFF22c55e),
            ),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline_rounded),
            selectedIcon: Icon(
              Icons.play_circle_rounded,
              color: Color(0xFF22c55e),
            ),
            label: 'Videos',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFF22c55e),
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
