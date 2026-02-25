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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1419) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.grey.shade100,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(0xFF22c55e).withOpacity(0.12),
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 64,
          destinations: [
            _navItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
            _navItem(
              Icons.sports_cricket_outlined,
              Icons.sports_cricket,
              'Matches',
            ),
            _navItem(Icons.newspaper_outlined, Icons.newspaper_rounded, 'News'),
            _navItem(
              Icons.play_circle_outline_rounded,
              Icons.play_circle_rounded,
              'Videos',
            ),
            _navItem(
              Icons.person_outline_rounded,
              Icons.person_rounded,
              'More',
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _navItem(
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    return NavigationDestination(
      icon: Icon(icon, size: 22),
      selectedIcon: Icon(activeIcon, size: 22, color: const Color(0xFF22c55e)),
      label: label,
    );
  }
}
