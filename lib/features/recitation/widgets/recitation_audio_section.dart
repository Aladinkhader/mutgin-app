import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/recitation_screen_controller.dart';

class RecitationScreenAudioSection extends StatelessWidget {
  final RecitationScreenController controller;

  const RecitationScreenAudioSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isRecording = controller.isRecording;
    final isProcessing = controller.isProcessing;
    final isListening = controller.isMicrophoneListening;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isRecording
              ? AppColors.gold.withValues(alpha: 0.35)
              : AppColors.surfaceSoft,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isRecording
                  ? AppColors.gold.withValues(alpha: 0.12)
                  : AppColors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording
                  ? Icons.mic_rounded
                  : Icons.mic_none_rounded,
              color: isRecording
                  ? AppColors.gold
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isProcessing
                      ? 'جاري تحليل التلاوة'
                      : isRecording
                          ? 'جاري الاستماع'
                          : 'الميكروفون جاهز',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  controller.microphoneError ??
                      (isListening
                          ? 'يستمع متقن إلى تلاوتك الآن.'
                          : 'اضغط على ابدأ التسميع للبدء.'),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
