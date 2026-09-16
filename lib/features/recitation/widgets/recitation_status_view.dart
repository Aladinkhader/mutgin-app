import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/recitation_result.dart';

class RecitationStatusView extends StatelessWidget {
  final RecitationResult result;

  const RecitationStatusView({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final status = _statusData(result.status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            status.icon,
            color: status.color,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: AppTextStyles.subtitle,
                ),
                if (result.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    result.errorMessage!,
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

  _StatusData _statusData(RecitationStatus status) {
    switch (status) {
      case RecitationStatus.listening:
        return const _StatusData(
          title: 'استمع للتلاوة',
          icon: Icons.mic_rounded,
          color: AppColors.emerald,
        );

      case RecitationStatus.processing:
        return const _StatusData(
          title: 'جارٍ تحليل التلاوة',
          icon: Icons.auto_awesome_rounded,
          color: AppColors.gold,
        );

      case RecitationStatus.correct:
        return const _StatusData(
          title: 'تلاوة صحيحة',
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
        );

      case RecitationStatus.mistake:
        return const _StatusData(
          title: 'تحتاج إلى مراجعة',
          icon: Icons.error_rounded,
          color: AppColors.error,
        );

      case RecitationStatus.completed:
        return const _StatusData(
          title: 'تم إكمال الآية',
          icon: Icons.verified_rounded,
          color: AppColors.success,
        );

      case RecitationStatus.idle:
        return const _StatusData(
          title: 'جاهز للتسميع',
          icon: Icons.play_circle_outline_rounded,
          color: AppColors.textSecondary,
        );
    }
  }
}

class _StatusData {
  final String title;
  final IconData icon;
  final Color color;

  const _StatusData({
    required this.title,
    required this.icon,
    required this.color,
  });
}
