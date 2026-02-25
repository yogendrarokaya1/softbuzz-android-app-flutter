import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/app/theme/app_theme.dart';
import 'package:softbuzz_app/features/auth/presentation/pages/login_page.dart';
import 'package:softbuzz_app/features/auth/presentation/state/auth_state.dart';
import 'package:softbuzz_app/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:softbuzz_app/features/splash/presentation/pages/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authViewModelProvider, (previous, next) {
      // previous == null means it's the initial build — let splash handle it
      if (previous == null) return;

      if (next.status == AuthStatus.unauthenticated) {
        // Only fires on RUNTIME logout, not app start
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoftBuzz',
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      home: const SplashScreen(), // splash is always the entry point
    );
  }
}
