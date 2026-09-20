import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../services/recitation/recitation_session_state.dart';

class RecitationSessionActions extends StatelessWidget {
  final RecitationSessionState state;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onReset;

  const RecitationSessionActions({
    super.key,
    required this.state,
    this.onStart,
    this.onStop,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isListening = state == RecitationSessionState.listening;
    final isPreparing = state == RecitationSessionState.preparing;
    final isAnalyzing = state == RecitationSessionState.analyzing;
    final isFinished =
        state == RecitationSessionState.completed ||
        state == RecitationSessionState.error;

    if (isFinished) {
      return Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'إعادة التسميع',
              icon: Icons.refresh_rounded,
              onPressed: onReset,
              filled: true,
            ),
          ),
        ],
      );
    }

    if (isListening) {
      return Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'إيقاف الاستماع',
              icon: Icons.stop_rounded,
              onPressed: onStop,
              filled: true,
              color: AppColors.error,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: isPreparing || isAnalyzing
                ? 'جاري التجهيز...'
                : 'ابدأ التسميع',
            icon: isAnalyzing
                ? Icons.auto_awesome_rounded
                : Icons.mic_rounded,
            onPressed:
                isPreparing || isAnalyzing ? null : onStart,
            filled: true,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final Color? color;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.filled,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color ?? AppColors.emerald,
          disabledBackgroundColor: AppColors.surfaceSoft,
          foregroundColor: AppColors.textPrimary,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}
