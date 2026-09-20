import 'package:flutter/material.dart';

import '../../features/home/screens/main_shell.dart';
import '../../features/quran/screens/mushaf_screen.dart';
import '../../features/memorization/screens/memorization_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen());

      case AppRoutes.home:
        return _page(const MainShell());

      case AppRoutes.quran:
        return _page(const MushafScreen());

      case AppRoutes.memorization:
        return _page(const MemorizationScreen());

      case AppRoutes.settings:
        return _page(const SettingsScreen());

      case AppRoutes.recitation:
        return _page(
          const Scaffold(
            body: Center(
              child: Text('التسميع'),
            ),
          ),
        );

      default:
        return _page(
          const Scaffold(
            body: Center(
              child: Text('الصفحة غير موجودة'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => child,
    );
  }
}
