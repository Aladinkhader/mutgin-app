import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class RecitationAccuracyCard extends StatelessWidget {
  final double accuracy;
  final int errorCount;

  const RecitationAccuracyCard({
    super.key,
    required this.accuracy,
    required this.errorCount,
  });

  @override
  Widget build(BuildContext context) {
    final safeAccuracy = accuracy.clamp(0.0, 1.0);
    final percentage = (safeAccuracy * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            height: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: CircularProgressIndicator(
                    value: safeAccuracy,
                    strokeWidth: 7,
                    backgroundColor: AppColors.surfaceSoft,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.gold,
                    ),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: AppTextStyles.gold.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'دقة التلاوة',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  errorCount == 0
                      ? 'لم يتم تسجيل أخطاء'
                      : '$errorCount مواضع تحتاج إلى مراجعة',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
