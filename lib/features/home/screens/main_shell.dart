import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    _QuranPlaceholder(),
    _MemorizationPlaceholder(),
    _SettingsPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.emerald.withValues(alpha: 0.28),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'القرآن',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'الحفظ',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

class _QuranPlaceholder extends StatelessWidget {
  const _QuranPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderPage(
      icon: Icons.menu_book_rounded,
      title: 'القرآن الكريم',
    );
  }
}

class _MemorizationPlaceholder extends StatelessWidget {
  const _MemorizationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderPage(
      icon: Icons.auto_stories_rounded,
      title: 'الحفظ والمراجعة',
    );
  }
}

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderPage(
      icon: Icons.settings_rounded,
      title: 'الإعدادات',
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PlaceholderPage({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.gold,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.headline,
          ),
        ],
      ),
    );
  }
}
