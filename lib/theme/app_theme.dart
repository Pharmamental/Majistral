import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.kiremit,
      primary: AppColors.kiremit,
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
