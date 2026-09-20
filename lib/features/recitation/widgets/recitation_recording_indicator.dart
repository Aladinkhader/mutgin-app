import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class RecitationRecordingIndicator extends StatelessWidget {
  final bool isRecording;
  final bool isProcessing;

  const RecitationRecordingIndicator({
    super.key,
    required this.isRecording,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = isRecording || isProcessing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.error.withValues(alpha: 0.10)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isActive
              ? AppColors.error.withValues(alpha: 0.30)
              : AppColors.surfaceSoft,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(
            active: isRecording,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            isRecording
                ? 'جاري التسجيل'
                : isProcessing
                    ? 'جاري تحليل التسجيل'
                    : 'التسجيل متوقف',
            style: AppTextStyles.caption.copyWith(
              color: isActive
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final bool active;

  const _PulseDot({
    required this.active,
  });

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _PulseDot oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.active && !oldWidget.active) {
      _controller.repeat(reverse: true);
    } else if (!widget.active && oldWidget.active) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = widget.active
            ? 0.85 + (_controller.value * 0.30)
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: widget.active
                  ? AppColors.error
                  : AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
