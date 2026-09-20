import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class RecitationProgress extends StatelessWidget {
  final int currentAyah;
  final int totalAyahs;
  final double progress;

  const RecitationProgress({
    super.key,
    required this.currentAyah,
    required this.totalAyahs,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.surfaceSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mic_rounded,
                color: AppColors.gold,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'تقدم التسميع',
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '$currentAyah / $totalAyahs',
                style: AppTextStyles.gold,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: safeProgress,
              minHeight: 7,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
