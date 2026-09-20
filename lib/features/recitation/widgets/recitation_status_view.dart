import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
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
    final info = _StatusInfo.fromStatus(result.status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: info.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: info.borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: info.iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              info.icon,
              color: info.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  result.errorMessage ?? info.subtitle,
                  style: AppTextStyles.caption,
                ),
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

class _StatusInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const _StatusInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  factory _StatusInfo.fromStatus(RecitationStatus status) {
    switch (status) {
      case RecitationStatus.listening:
        return const _StatusInfo(
          title: 'جاري الاستماع',
          subtitle: 'متقن يستمع إلى تلاوتك...',
          icon: Icons.mic_rounded,
          iconColor: AppColors.gold,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x44D6B56A),
        );

      case RecitationStatus.processing:
        return const _StatusInfo(
          title: 'جاري التحليل',
          subtitle: 'يتم تحليل التلاوة...',
          icon: Icons.auto_awesome_rounded,
          iconColor: AppColors.emerald,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x441D6B5C),
        );

      case RecitationStatus.correct:
        return const _StatusInfo(
          title: 'تلاوة صحيحة',
          subtitle: 'أحسنت، لم يتم اكتشاف أخطاء.',
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.success,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x4455C99A),
        );

      case RecitationStatus.mistake:
        return const _StatusInfo(
          title: 'تحتاج إلى مراجعة',
          subtitle: 'تم اكتشاف مواضع تحتاج إلى مراجعة.',
          icon: Icons.info_rounded,
          iconColor: AppColors.error,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x44E97979),
        );

      case RecitationStatus.completed:
        return const _StatusInfo(
          title: 'اكتملت التلاوة',
          subtitle: 'أحسنت، اكتملت جلسة التسميع.',
          icon: Icons.task_alt_rounded,
          iconColor: AppColors.success,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x4455C99A),
        );

      case RecitationStatus.idle:
        return const _StatusInfo(
          title: 'جاهز للتسميع',
          subtitle: 'ابدأ التسميع عندما تكون مستعداً.',
          icon: Icons.mic_none_rounded,
          iconColor: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: AppColors.surfaceSoft,
        );
    }
  }
}
