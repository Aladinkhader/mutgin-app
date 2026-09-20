import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class MushafToolbar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onPageSelector;
  final VoidCallback onSearch;
  final VoidCallback onBookmark;

  const MushafToolbar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onPageSelector,
    required this.onSearch,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.surfaceSoft,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onSearch,
            tooltip: 'بحث',
            icon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: onBookmark,
            tooltip: 'علامة مرجعية',
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.gold,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onPageSelector,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                ),
                child: Column(
                  children: [
                    Text(
                      'صفحة $currentPage',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'من $totalPages',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onNextPage,
            tooltip: 'الصفحة التالية',
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: onPreviousPage,
            tooltip: 'الصفحة السابقة',
            icon: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
