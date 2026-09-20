import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../services/recitation/recitation_session_state.dart';

class RecitationSessionStatus extends StatelessWidget {
  final RecitationSessionState state;
  final double accuracy;
  final int errorCount;

  const RecitationSessionStatus({
    super.key,
    required this.state,
    required this.accuracy,
    required this.errorCount,
  });

  @override
  Widget build(BuildContext context) {
    final info = _StatusInfo.fromState(state);

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
                  _buildSubtitle(),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          if (state == RecitationSessionState.completed ||
              state == RecitationSessionState.error)
            Text(
              '${(accuracy * 100).round()}%',
              style: AppTextStyles.gold,
            ),
        ],
      ),
    );
  }

  String _buildSubtitle() {
    switch (state) {
      case RecitationSessionState.idle:
        return 'ابدأ جلسة التسميع عندما تكون مستعداً.';

      case RecitationSessionState.preparing:
        return 'يتم تجهيز جلسة التسميع...';

      case RecitationSessionState.listening:
        return 'متقن يستمع إلى تلاوتك...';

      case RecitationSessionState.analyzing:
        return 'يتم تحليل التلاوة ومقارنتها بالآية...';

      case RecitationSessionState.completed:
        return 'أحسنت، لم يتم اكتشاف أخطاء في هذه الآية.';

      case RecitationSessionState.error:
        return errorCount == 1
            ? 'تم اكتشاف موضع واحد يحتاج إلى مراجعة.'
            : 'تم اكتشاف $errorCount مواضع تحتاج إلى مراجعة.';
    }
  }
}

class _StatusInfo {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const _StatusInfo({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  factory _StatusInfo.fromState(RecitationSessionState state) {
    switch (state) {
      case RecitationSessionState.listening:
        return const _StatusInfo(
          title: 'جاري الاستماع',
          icon: Icons.mic_rounded,
          iconColor: AppColors.gold,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x44D6B56A),
        );

      case RecitationSessionState.preparing:
        return const _StatusInfo(
          title: 'جاري التجهيز',
          icon: Icons.hourglass_top_rounded,
          iconColor: AppColors.gold,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x44D6B56A),
        );

      case RecitationSessionState.analyzing:
        return const _StatusInfo(
          title: 'جاري التحليل',
          icon: Icons.auto_awesome_rounded,
          iconColor: AppColors.emerald,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x441D6B5C),
        );

      case RecitationSessionState.completed:
        return const _StatusInfo(
          title: 'تلاوة صحيحة',
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.success,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x4455C99A),
        );

      case RecitationSessionState.error:
        return const _StatusInfo(
          title: 'تحتاج إلى مراجعة',
          icon: Icons.info_rounded,
          iconColor: AppColors.error,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: Color(0x44E97979),
        );

      case RecitationSessionState.idle:
        return const _StatusInfo(
          title: 'جاهز للتسميع',
          icon: Icons.mic_none_rounded,
          iconColor: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceElevated,
          borderColor: AppColors.surfaceSoft,
        );
    }
  }
}
