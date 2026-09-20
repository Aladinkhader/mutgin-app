import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SurahHeader extends StatelessWidget {
  final String surahName;
  final int surahNumber;
  final int ayahCount;
  final String revelationType;

  const SurahHeader({
    super.key,
    required this.surahName,
    required this.surahNumber,
    required this.ayahCount,
    required this.revelationType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$surahNumber',
              style: AppTextStyles.gold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surahName,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$revelationType • $ayahCount آيات',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.menu_book_rounded,
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }
}
