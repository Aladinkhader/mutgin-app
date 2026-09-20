import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: AppSpacing.screenPadding,
              sliver: SliverToBoxAdapter(
                child: _Header(
                  onSettingsPressed: () {},
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: _ContinueCard(
                  onPressed: () {},
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'ابدأ رحلتك',
                  style: AppTextStyles.title,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    _ActionCard(
                      icon: Icons.menu_book_rounded,
                      title: 'القرآن الكريم',
                      subtitle: 'اقرأ وتصفح المصحف',
                      accent: AppColors.gold,
                      onPressed: () {},
                    ),
                    _ActionCard(
                      icon: Icons.mic_rounded,
                      title: 'التسميع',
                      subtitle: 'سمّع من حفظك',
                      accent: AppColors.emerald,
                      onPressed: () {},
                    ),
                    _ActionCard(
                      icon: Icons.auto_stories_rounded,
                      title: 'الحفظ',
                      subtitle: 'خطتك ومراجعتك',
                      accent: AppColors.softGold,
                      onPressed: () {},
                    ),
                    _ActionCard(
                      icon: Icons.bar_chart_rounded,
                      title: 'إحصائياتي',
                      subtitle: 'تابع تقدمك',
                      accent: AppColors.success,
                      onPressed: () {},
                    ),
                  ],
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const _Header({
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'متقن',
                style: AppTextStyles.display,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'رفيقك في حفظ القرآن الكريم',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onSettingsPressed,
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'الإعدادات',
        ),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueCard({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.forest,
            AppColors.surfaceElevated,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.elevated,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.gold,
              size: 30,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تابع من حيث توقفت',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'لم تبدأ جلسة بعد',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.surfaceSoft,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 25,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.subtitle,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTextStyles.caption,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
