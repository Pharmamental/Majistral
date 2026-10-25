import 'package:flutter/material.dart';

// Tasarım tokenları: her ekranın kullandığı ortak renk, boşluk, köşe ve yazı
// ölçüleri. Yeni arayüz bunlardan beslenir ki ekranlar birbirine benzesin.

class AppColors {
  AppColors._();

  static const Color kiremit = Color(0xFFB7410E);
  static const Color cream = Color(0xFFF3E5C8);
  static const Color ink = Colors.black87;

  // İstasyon kademeleri (eski kart renkleri).
  static const Color rusty = Color(0xFF8D6E52);
  static const Color goodCondition = Color(0xFF607D8B);
  static const Color advanced = Color(0xFF00ACC1);
}

class AppFont {
  AppFont._();

  static const double caption = 11.0;
  static const double body = 13.0;
  static const double title = 15.0;
  static const double heading = 20.0;
}

class AppSpace {
  AppSpace._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}

class AppRadius {
  AppRadius._();

  static const double sm = 10.0;
  static const double lg = 20.0;
}
