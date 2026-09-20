import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/surah.dart';
import '../../../services/quran/local_quran_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final LocalQuranService _quranService = const LocalQuranService();

  List<Surah> _surahs = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    final surahs = await _quranService.getSurahs();

    if (!mounted) {
      return;
    }

    setState(() {
      _surahs = surahs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.gold,
              ),
            )
          : ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: _surahs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final surah = _surahs[index];

                return _SurahCard(
                  surah: surah,
                  onTap: () {},
                );
              },
            ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahCard({
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${surah.number}',
                  style: AppTextStyles.gold,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.arabicName,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${surah.numberOfAyahs} آيات • ${surah.revelationType}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
