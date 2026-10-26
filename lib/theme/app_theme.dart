import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.kiremit,
      primary: AppColors.kiremit,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
  return base.copyWith(
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.kiremitSoft,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => AppText.label(
          size: 12,
          color: states.contains(WidgetState.selected) ? AppColors.accentText : AppColors.inkMuted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? AppColors.kiremit : AppColors.inkMuted,
        ),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.card))),
    ),
  );
}
