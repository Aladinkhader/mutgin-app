import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';
import '../../../services/quran/local_quran_service.dart';
import '../widgets/mushaf_page.dart';

class MushafScreen extends StatefulWidget {
  const MushafScreen({super.key});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  final LocalQuranService _quranService = const LocalQuranService();

  final PageController _pageController = PageController();

  int _currentPage = 1;
  List<Ayah> _ayahs = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final ayahs = await _quranService.getSurahAyahs(1);

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
        _errorMessage = 'تعذر تحميل القرآن الكريم.';
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage <= 1) {
      return;
    }

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _goToNextPage() {
    if (_currentPage >= AppConstants.totalPages) {
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المصحف'),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'اختيار الصفحة',
            icon: const Icon(
              Icons.grid_view_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _PageIndicator(
              pageNumber: _currentPage,
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: _buildContent(),
              ),
            ),
            _PageControls(
              onPrevious: _goToPreviousPage,
              onNext: _goToNextPage,
              canGoPrevious: _currentPage > 1,
              canGoNext: _currentPage < AppConstants.totalPages,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.gold,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
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
              onPressed: _loadPage,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: AppConstants.totalPages,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page + 1;
        });
      },
      itemBuilder: (context, index) {
        return MushafPage(
          pageNumber: index + 1,
          surahName: index == 0 ? 'الفاتحة' : null,
          ayahs: index == 0 ? _ayahs : const [],
        );
      },
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int pageNumber;

  const _PageIndicator({
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 18,
            color: AppColors.gold,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'صفحة $pageNumber من ${AppConstants.totalPages}',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}

class _PageControls extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  const _PageControls({
    required this.onPrevious,
    required this.onNext,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton.filledTonal(
            onPressed: canGoPrevious ? onPrevious : null,
            icon: const Icon(
              Icons.chevron_left_rounded,
            ),
            tooltip: 'الصفحة السابقة',
          ),
          const SizedBox(width: AppSpacing.lg),
          IconButton.filledTonal(
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(
              Icons.chevron_right_rounded,
            ),
            tooltip: 'الصفحة التالية',
          ),
        ],
      ),
    );
  }
}
