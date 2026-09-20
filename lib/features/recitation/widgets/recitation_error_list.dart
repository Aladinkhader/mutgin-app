import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/recitation_error.dart';

class RecitationErrorList extends StatelessWidget {
  final List<RecitationError> errors;

  const RecitationErrorList({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'مواضع تحتاج إلى مراجعة',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...errors.map(
            (error) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.sm,
              ),
              child: _ErrorItem(error: error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorItem extends StatelessWidget {
  final RecitationError error;

  const _ErrorItem({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              error.expectedWord.isEmpty
                  ? 'كلمة زائدة'
                  : error.expectedWord,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.body,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _ErrorTypeLabel(type: error.type),
        ],
      ),
    );
  }
}

class _ErrorTypeLabel extends StatelessWidget {
  final RecitationErrorType type;

  const _ErrorTypeLabel({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _label(type),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.error,
      ),
    );
  }

  String _label(RecitationErrorType type) {
    switch (type) {
      case RecitationErrorType.omitted:
        return 'مفقودة';
      case RecitationErrorType.added:
        return 'زائدة';
      case RecitationErrorType.substituted:
        return 'مختلفة';
      case RecitationErrorType.repeated:
        return 'مكررة';
      case RecitationErrorType.pronunciation:
        return 'نطق';
      case RecitationErrorType.unknown:
        return 'مراجعة';
    }
  }
}
