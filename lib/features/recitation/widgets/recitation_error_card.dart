import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/recitation_error.dart';

class RecitationErrorCard extends StatelessWidget {
  final RecitationError error;
  final int index;

  const RecitationErrorCard({
    super.key,
    required this.error,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (error.expectedWord.isNotEmpty)
                  Text(
                    'المطلوب: ${error.expectedWord}',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodySecondary,
                  ),
                if (error.recognizedWord != null &&
                    error.recognizedWord!.isNotEmpty)
                  Text(
                    'المسموع: ${error.recognizedWord}',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodySecondary.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  error.message,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _title {
    switch (error.type) {
      case RecitationErrorType.omitted:
        return 'كلمة مفقودة';

      case RecitationErrorType.added:
        return 'كلمة زائدة';

      case RecitationErrorType.substituted:
        return 'كلمة مختلفة';

      case RecitationErrorType.repeated:
        return 'تكرار كلمة';

      case RecitationErrorType.pronunciation:
        return 'مراجعة النطق';

      case RecitationErrorType.unknown:
        return 'موضع يحتاج إلى مراجعة';
    }
  }
}
