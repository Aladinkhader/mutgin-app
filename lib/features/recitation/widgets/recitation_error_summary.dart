import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/recitation_error.dart';

class RecitationErrorSummary extends StatelessWidget {
  final List<RecitationError> errors;

  const RecitationErrorSummary({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    final omitted = errors
        .where((error) => error.type == RecitationErrorType.omitted)
        .length;

    final added = errors
        .where((error) => error.type == RecitationErrorType.added)
        .length;

    final substituted = errors
        .where((error) => error.type == RecitationErrorType.substituted)
        .length;

    if (errors.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.25),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'لم يتم اكتشاف أخطاء في هذه التلاوة.',
                style: AppTextStyles.body,
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'ملخص المراجعة',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (omitted > 0)
                _CountChip(
                  label: 'مفقودة',
                  count: omitted,
                ),
              if (added > 0)
                _CountChip(
                  label: 'زائدة',
                  count: added,
                ),
              if (substituted > 0)
                _CountChip(
                  label: 'مختلفة',
                  count: substituted,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final int count;

  const _CountChip({
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$label: $count',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }
}
