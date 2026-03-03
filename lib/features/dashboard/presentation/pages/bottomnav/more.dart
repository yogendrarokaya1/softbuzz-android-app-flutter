import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:softbuzz_app/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:softbuzz_app/features/auth/presentation/pages/change_password_page.dart';
import 'package:softbuzz_app/features/dashboard/presentation/widgets/softbuzz_app_bar.dart';
import 'package:softbuzz_app/features/matches/presentation/pages/matches_screen.dart';
import 'package:softbuzz_app/features/news/presentation/pages/news_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F1419)
          : const Color(0xFFF8F9FE),
      appBar: const SoftBuzzAppBar(title: 'More'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Profile Card ─────────────────────────────────────────
          if (user != null) ...[
            _ProfileCard(
              user: user,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],

          // ── Cricket ──────────────────────────────────────────────
          _SectionLabel('Cricket'),
          _MenuItem(
            icon: Icons.sports_cricket,
            iconColor: const Color(0xFF22c55e),
            label: 'All Matches',
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MatchesScreen()),
            ),
          ),
          _MenuItem(
            icon: Icons.newspaper_rounded,
            iconColor: const Color(0xFF3b82f6),
            label: 'News & Articles',
            isDark: isDark,
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
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            ),
          ),
          _MenuItem(
            icon: Icons.lock_outline,
            iconColor: const Color(0xFFf97316),
            label: 'Change Password',
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
            ),
          ),
          const SizedBox(height: 16),

          // ── App ───────────────────────────────────────────────────
          _SectionLabel('App'),
          _MenuItem(
            icon: Icons.info_outline,
            iconColor: Colors.grey,
            label: 'About SoftBuzz',
            isDark: isDark,
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.star_outline,
            iconColor: const Color(0xFFf59e0b),
            label: 'Rate the App',
            isDark: isDark,
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
                    fontFamily: 'Inter',
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

// ── Profile Card ──────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onEdit;
  const _ProfileCard({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        user.profilePicture != null && user.profilePicture!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar with network image support
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF22c55e), width: 2),
            ),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      user.profilePicture!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _AvatarFallback(name: user.firstName ?? 'U'),
                    )
                  : _AvatarFallback(name: user.firstName ?? 'U'),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (user.username?.isNotEmpty == true)
                  Text(
                    '@${user.username}',
                    style: const TextStyle(
                      color: Color(0xFF22c55e),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                if (user.email?.isNotEmpty == true)
                  Text(
                    user.email!,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
              ],
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF22c55e).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF22c55e).withOpacity(0.4),
                ),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF22c55e),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;
  const _AvatarFallback({required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF22c55e),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

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
          fontFamily: 'Inter',
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
  final bool isDark;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F26) : Colors.white,
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
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
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
