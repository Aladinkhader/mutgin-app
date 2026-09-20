import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';

class AyahRecitationCard extends StatelessWidget {
  final Ayah ayah;
  final bool isActive;
  final bool showText;

  const AyahRecitationCard({
    super.key,
    required this.ayah,
    this.isActive = false,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.emerald.withValues(alpha: 0.16)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isActive
              ? AppColors.gold.withValues(alpha: 0.55)
              : AppColors.surfaceSoft,
          width: isActive ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.gold.withValues(alpha: 0.16)
                    : AppColors.surfaceElevated,
              ),
              child: Text(
                '${ayah.ayahNumber}',
                style: AppTextStyles.gold.copyWith(
                  fontSize: 13,
                ),
              ),
            ),
          ),
          if (showText) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              ayah.text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.body.copyWith(
                fontSize: 24,
                height: 2.1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.xl),
            const Center(
              child: Icon(
                Icons.visibility_off_outlined,
                color: AppColors.textMuted,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'أكمل التسميع من حفظك',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ],
      ),
    );
  }
}
