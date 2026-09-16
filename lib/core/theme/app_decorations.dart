import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

abstract final class AppDecorations {
  static BoxDecoration card({
    Color color = AppColors.surface,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: border,
      boxShadow: AppShadows.card,
    );
  }

  static BoxDecoration elevatedCard() {
    return BoxDecoration(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadius.card),
      boxShadow: AppShadows.elevated,
    );
  }

  static BoxDecoration goldAccent() {
    return BoxDecoration(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(
        color: AppColors.gold.withValues(alpha: 0.28),
        width: 1,
      ),
      boxShadow: AppShadows.goldGlow,
    );
  }

  static BoxDecoration emeraldAccent() {
    return BoxDecoration(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(
        color: AppColors.emerald.withValues(alpha: 0.35),
        width: 1,
      ),
      boxShadow: AppShadows.emeraldGlow,
    );
  }

  static BoxDecoration outlined({
    Color borderColor = AppColors.surfaceSoft,
  }) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
    );
  }
}
