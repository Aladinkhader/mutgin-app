import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';
import '../../../models/recitation_error.dart';
import '../../../services/recitation/recitation_session_state.dart';
import 'recitation_accuracy_card.dart';
import 'recitation_errors_section.dart';
import 'recitation_session_status.dart';

class RecitationSessionPanel extends StatelessWidget {
  final Ayah? currentAyah;
  final RecitationSessionState state;
  final double accuracy;
  final List<RecitationError> errors;

  const RecitationSessionPanel({
    super.key,
    required this.currentAyah,
    required this.state,
    required this.accuracy,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    if (currentAyah == null) {
      return const _EmptySession();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AyahHeader(
          ayah: currentAyah!,
        ),
        const SizedBox(height: AppSpacing.md),
        RecitationSessionStatus(
          state: state,
          accuracy: accuracy,
          errorCount: errors.length,
        ),
        if (state == RecitationSessionState.completed ||
            state == RecitationSessionState.error) ...[
          const SizedBox(height: AppSpacing.md),
          RecitationAccuracyCard(
            accuracy: accuracy,
            errorCount: errors.length,
          ),
          if (errors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            RecitationErrorsSection(
              errors: errors,
            ),
          ],
        ],
      ],
    );
  }
}

class _AyahHeader extends StatelessWidget {
  final Ayah ayah;

  const _AyahHeader({
    required this.ayah,
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
          color: AppColors.gold.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${ayah.ayahNumber}',
                  style: AppTextStyles.gold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Text(
                  'الآية الحالية',
                  style: AppTextStyles.subtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            ayah.text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(
              fontSize: 21,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySession extends StatelessWidget {
  const _EmptySession();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.surfaceSoft,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.mic_none_rounded,
            color: AppColors.gold,
            size: 38,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'ابدأ جلسة التسميع',
            style: AppTextStyles.subtitle,
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            'اختر آية ثم ابدأ التسميع من حفظك.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}
