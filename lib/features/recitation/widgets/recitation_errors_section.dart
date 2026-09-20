import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/recitation_error.dart';
import 'recitation_error_card.dart';

class RecitationErrorsSection extends StatelessWidget {
  final List<RecitationError> errors;

  const RecitationErrorsSection({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
              size: 34,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'لم يتم اكتشاف أخطاء',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'استمر بهذا الأداء في مراجعة الآية.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.rate_review_outlined,
              color: AppColors.error,
              size: 21,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Text(
                'مواضع تحتاج إلى مراجعة',
                style: AppTextStyles.subtitle,
              ),
            ),
            Text(
              '${errors.length}',
              style: AppTextStyles.gold,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < errors.length; index++) ...[
          RecitationErrorCard(
            error: errors[index],
            index: index + 1,
          ),
          if (index < errors.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
