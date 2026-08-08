import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4F46E5);     // Indigo #4F46E5
  static const Color secondary = Color(0xFF8B5CF6);   // Violet #8B5CF6
  static const Color success = Color(0xFF10B981);     // Emerald #10B981
  static const Color warning = Color(0xFFF59E0B);     // Amber #F59E0B
  static const Color error = Color(0xFFEF4444);       // Rose #EF4444

  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0F172A);

  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double card = 16.0; // 16px border radius required
  static const double pill = 999.0;
}

class AppConstants {
  static const String appName = 'AIDA';
  static const String appTitle = 'AI Personal Assistant';
  static const String appVersion = '1.0.0';
  static const String developer = 'Marlo Romero';
  static const String university = 'College of Information and Communications Technology';
  static const String course = 'BSIT Mobile Programming Final Project';
}