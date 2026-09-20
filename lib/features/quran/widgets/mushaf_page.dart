import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';

class MushafPage extends StatelessWidget {
  final int pageNumber;
  final String? surahName;
  final List<Ayah> ayahs;
  final int? activeAyahNumber;
  final ValueChanged<Ayah>? onAyahTap;

  const MushafPage({
    super.key,
    required this.pageNumber,
    required this.ayahs,
    this.surahName,
    this.activeAyahNumber,
    this.onAyahTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1DF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.elevated,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Column(
          children: [
            _PageHeader(
              pageNumber: pageNumber,
              surahName: surahName,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ayahs.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد آيات في هذه الصفحة',
                        style: TextStyle(
                          color: Color(0xFF6D6658),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final ayah in ayahs)
                            _AyahText(
                              ayah: ayah,
                              isActive: ayah.ayahNumber == activeAyahNumber,
                              onTap: onAyahTap == null
                                  ? null
                                  : () => onAyahTap!(ayah),
                            ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.xs),
            _PageFooter(pageNumber: pageNumber),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final int pageNumber;
  final String? surahName;

  const _PageHeader({
    required this.pageNumber,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFD2C7AC),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
              ),
              child: Text(
                surahName ?? 'القرآن الكريم',
                style: const TextStyle(
                  color: Color(0xFF665D4D),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFD2C7AC),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AyahText extends StatelessWidget {
  final Ayah ayah;
  final bool isActive;
  final VoidCallback? onTap;

  const _AyahText({
    required this.ayah,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = '${ayah.text} ﴿${ayah.ayahNumber}﴾';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.gold.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          text,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Color(0xFF29261F),
            fontSize: 23,
            height: 2.05,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PageFooter extends StatelessWidget {
  final int pageNumber;

  const _PageFooter({
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFD2C7AC),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
          ),
          child: Text(
            '$pageNumber',
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF6D6658),
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFD2C7AC),
          ),
        ),
      ],
    );
  }
}
