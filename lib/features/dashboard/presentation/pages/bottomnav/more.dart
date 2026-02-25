import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:softbuzz_app/features/matches/presentation/pages/matches_screen.dart';
import 'package:softbuzz_app/features/news/presentation/pages/news_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0f1117)
          : const Color(0xFFf8fafc),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0f1117) : Colors.white,
        elevation: 0,
        title: const Text(
          'More',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── User profile card ─────────────────────────────────────
          if (user != null)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF22c55e),
                    child: Text(
                      (user.firstName?.isNotEmpty == true
                              ? user.firstName![0]
                              : 'U')
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName ?? ''} ${user.lastName ?? ''}'
                              .trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (user.email?.isNotEmpty == true)
                          Text(
                            user.email!,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

          // ── Cricket ───────────────────────────────────────────────
          _SectionLabel('Cricket'),
          _MenuItem(
            icon: Icons.sports_cricket,
            iconColor: const Color(0xFF22c55e),
            label: 'All Matches',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MatchesScreen()),
            ),
          ),
          _MenuItem(
            icon: Icons.newspaper_rounded,
            iconColor: const Color(0xFF3b82f6),
            label: 'News & Articles',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsScreen()),
            ),
          ),
          const SizedBox(height: 16),

          // ── Account ───────────────────────────────────────────────
          _SectionLabel('Account'),
          _MenuItem(
            icon: Icons.person_outline,
            iconColor: const Color(0xFFa855f7),
            label: 'Edit Profile',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.lock_outline,
            iconColor: const Color(0xFFf97316),
            label: 'Change Password',
            onTap: () {},
          ),
          const SizedBox(height: 16),

          // ── App ───────────────────────────────────────────────────
          _SectionLabel('App'),
          _MenuItem(
            icon: Icons.info_outline,
            iconColor: Colors.grey,
            label: 'About SoftBuzz',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.star_outline,
            iconColor: const Color(0xFFf59e0b),
            label: 'Rate the App',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // ── Logout ────────────────────────────────────────────────
          if (user != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    ref.read(authViewModelProvider.notifier).logout(),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFef4444),
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFef4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFef4444)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e2433) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 13,
          color: Colors.grey,
        ),
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
