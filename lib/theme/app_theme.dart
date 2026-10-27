import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Bitter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.kobalt,
      primary: AppColors.kobalt,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
  return base.copyWith(
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.paper))),
    ),
  );
}
