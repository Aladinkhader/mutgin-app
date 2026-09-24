import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';
import '../../../models/surah.dart';
import '../../../services/quran/local_quran_service.dart';
import '../../recitation/screens/recitation_screen.dart';

class SurahScreen extends StatefulWidget {
  final Surah surah;

  const SurahScreen({
    super.key,
    required this.surah,
  });

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final LocalQuranService _quranService = const LocalQuranService();

  List<Ayah> _ayahs = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final ayahs = await _quranService.getSurahAyahs(
        widget.surah.number,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _ayahs = ayahs;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _ayahs = const [];
        _isLoading = false;
        _errorMessage = 'تعذر تحميل آيات سورة ${widget.surah.arabicName}.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.arabicName),
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
                onPressed: _loadAyahs,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_ayahs.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Text(
            'لا توجد آيات متاحة حالياً.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: _ayahs.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final ayah = _ayahs[index];

        return _AyahCard(
          ayah: ayah,
          onRecitationPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecitationScreen(
                  ayah: ayah,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AyahCard extends StatelessWidget {
  final Ayah ayah;
  final VoidCallback onRecitationPressed;

  const _AyahCard({
    required this.ayah,
    required this.onRecitationPressed,
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
          color: AppColors.surfaceSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${ayah.ayahNumber}',
                  style: AppTextStyles.gold.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRecitationPressed,
                tooltip: 'التسميع',
                icon: const Icon(
                  Icons.mic_none_rounded,
                  color: AppColors.gold,
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
              fontSize: 23,
              height: 2.1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
