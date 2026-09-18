import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema global do app.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
      );
}
