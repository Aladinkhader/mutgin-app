import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class RecitationAudioControls extends StatelessWidget {
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onCancel;

  const RecitationAudioControls({
    super.key,
    required this.isRecording,
    required this.isProcessing,
    this.onStart,
    this.onStop,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = isProcessing;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: disabled
                ? null
                : isRecording
                    ? onStop
                    : onStart,
            icon: Icon(
              isRecording
                  ? Icons.stop_rounded
                  : Icons.mic_rounded,
            ),
            label: Text(
              isRecording ? 'إيقاف التسميع' : 'ابدأ التسميع',
              style: AppTextStyles.button,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: isRecording
                  ? AppColors.error
                  : AppColors.emerald,
              foregroundColor: AppColors.textPrimary,
              disabledBackgroundColor: AppColors.surfaceSoft,
              disabledForegroundColor: AppColors.textMuted,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppRadius.button,
                ),
              ),
            ),
          ),
        ),
        if (isRecording) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: onCancel,
            tooltip: 'إلغاء',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceElevated,
              foregroundColor: AppColors.textSecondary,
              minimumSize: const Size(52, 52),
            ),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ],
    );
  }
}
