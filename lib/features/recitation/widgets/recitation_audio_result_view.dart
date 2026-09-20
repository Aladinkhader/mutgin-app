import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/recitation_result.dart';

class RecitationAudioResultView extends StatelessWidget {
  final RecitationResult result;

  const RecitationAudioResultView({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    if (result.status == RecitationStatus.idle ||
        result.status == RecitationStatus.listening) {
      return const SizedBox.shrink();
    }

    final isProcessing = result.status == RecitationStatus.processing;
    final isCorrect = result.status == RecitationStatus.correct;
    final isMistake = result.status == RecitationStatus.mistake;

    final Color iconColor;
    final IconData icon;
    final String title;

    if (isProcessing) {
      iconColor = AppColors.gold;
      icon = Icons.auto_awesome_rounded;
      title = 'جاري تحليل التلاوة';
    } else if (isCorrect) {
      iconColor = AppColors.success;
      icon = Icons.check_circle_rounded;
      title = 'تلاوة صحيحة';
    } else if (isMistake) {
      iconColor = AppColors.error;
      icon = Icons.info_rounded;
      title = 'تحتاج إلى مراجعة';
    } else {
      iconColor = AppColors.textSecondary;
      icon = Icons.info_outline_rounded;
      title = 'نتيجة التسميع';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (result.errorMessage != null)
                  Text(
                    result.errorMessage!,
                    style: AppTextStyles.caption,
                  ),
                if (result.recognizedText != null &&
                    result.recognizedText!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'النص المتعرف عليه',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    result.recognizedText!,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ],
            ),
          ),
          if (result.confidence > 0)
            Text(
              '${(result.confidence * 100).round()}%',
              style: AppTextStyles.gold,
            ),
        ],
      ),
    );
  }
}
