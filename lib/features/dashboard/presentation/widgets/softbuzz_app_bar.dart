import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SoftBuzzAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final bool transparent;
  final Color? backgroundColor;

  const SoftBuzzAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
    this.transparent = false,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        backgroundColor ??
        (transparent
            ? Colors.transparent
            : isDark
            ? const Color(0xFF0F1419)
            : Colors.white);

    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                width: 34,
                height: 34,
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
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFE8EAED) : const Color(0xFF0F1419),
          letterSpacing: -0.3,
        ),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
        ),
      ),
    );
  }
}

// Home AppBar with logo - used only on HomeScreen
class SoftBuzzHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final List<Widget>? actions;

  const SoftBuzzHomeAppBar({super.key, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: isDark
                    ? const Color(0xFFE8EAED)
                    : const Color(0xFF0F1419),
              ),
              children: const [
                TextSpan(
                  text: 'Soft',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: 'Buzz',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF22c55e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
        ),
      ),
    );
  }
}
