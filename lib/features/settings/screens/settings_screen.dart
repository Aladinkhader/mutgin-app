import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _Section(
              title: 'التطبيق',
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'الإشعارات',
                  subtitle: 'التذكيرات والتنبيهات',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.volume_up_outlined,
                  title: 'الصوت',
                  subtitle: 'إعدادات الصوت والتلاوة',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'المظهر',
                  subtitle: 'تخصيص مظهر متقن',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _Section(
              title: 'المصحف والتسميع',
              children: [
                _SettingsTile(
                  icon: Icons.menu_book_outlined,
                  title: 'إعدادات المصحف',
                  subtitle: 'طريقة عرض المصحف',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.mic_none_rounded,
                  title: 'إعدادات التسميع',
                  subtitle: 'خيارات التعرف على التلاوة',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _Section(
              title: 'حول متقن',
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'عن التطبيق',
                  subtitle: AppConstants.appDescription,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          'تطبيق متقن لحفظ القرآن الكريم وتسميعه بذكاء',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
          ),
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.gold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: AppColors.surfaceSoft,
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(
                    height: 1,
                    indent: 64,
                    endIndent: AppSpacing.md,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.emerald.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          color: AppColors.emerald,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.subtitle.copyWith(
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
