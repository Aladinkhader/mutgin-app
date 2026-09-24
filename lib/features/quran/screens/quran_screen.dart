import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/surah.dart';
import '../../../services/quran/local_quran_service.dart';
import 'surah_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final LocalQuranService _quranService = const LocalQuranService();

  List<Surah> _surahs = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final surahs = await _quranService.getSurahs();

      if (!mounted) {
        return;
      }

      setState(() {
        _surahs = surahs;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _surahs = const [];
        _isLoading = false;
        _errorMessage = 'تعذر تحميل بيانات القرآن الكريم.';
      });
    }
  }

  void _openSurah(Surah surah) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SurahScreen(
          surah: surah,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.gold,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppColors.gold,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: _loadSurahs,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_surahs.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 56,
                color: AppColors.gold,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'لا توجد بيانات للقرآن الكريم حالياً.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: _loadSurahs,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: _surahs.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final surah = _surahs[index];

        return _SurahCard(
          surah: surah,
          onTap: () => _openSurah(surah),
        );
      },
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
