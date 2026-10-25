import 'package:flutter/material.dart';

import 'bevel.dart';
import 'tokens.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.kiremit,
    scaffoldBackgroundColor: AppColors.cream,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const BevelBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(color: Color(0x40000000), width: 5),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl, vertical: AppSpace.md),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.3),
      ),
    ),
  );
}
