import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.67';
  static const int _port = 5050;

  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get baseUrl => 'http://$_host:$_port';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ════════════════════════════════════════════
  // AUTH
  // ════════════════════════════════════════════
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String whoAmI = '/api/auth/whoami';
  static const String updateProfile = '/api/auth/update-profile';
  static const String changePassword = '/api/auth/update-profile';
  static const String requestPasswordReset = '/api/auth/request-password-reset';
  static String resetPassword(String token) =>
      '/api/auth/reset-password/$token';

  // ════════════════════════════════════════════
  // MATCHES
  // ════════════════════════════════════════════
  static const String matches = '/api/matches';
  static const String matchesHome = '/api/matches/home';
  static const String matchesLive = '/api/matches/live';
  static const String matchesUpcoming = '/api/matches/upcoming';
  static const String matchesRecent = '/api/matches/recent';
  static String matchById(String id) => '/api/matches/$id';

  // ════════════════════════════════════════════
  // SCORECARD
  // ════════════════════════════════════════════
  static String scorecard(String matchId) => '/api/scorecards/$matchId';

  // ════════════════════════════════════════════
  // NEWS
  // ════════════════════════════════════════════
  static const String news = '/api/news';
  static const String newsFeatured = '/api/news/featured';
  static const String newsBreaking = '/api/news/breaking';
  static const String newsLatest = '/api/news/latest';
  static String newsBySlug(String slug) => '/api/news/$slug';
}
