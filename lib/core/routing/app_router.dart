import 'package:flutter/material.dart';

import 'app_routes.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(
          const Scaffold(
            body: SizedBox.shrink(),
          ),
        );

      case AppRoutes.home:
        return _page(
          const Scaffold(
            body: SizedBox.shrink(),
          ),
        );

      case AppRoutes.quran:
        return _page(
          const Scaffold(
            body: SizedBox.shrink(),
          ),
        );

      case AppRoutes.recitation:
        return _page(
          const Scaffold(
            body: SizedBox.shrink(),
          ),
        );

      case AppRoutes.memorization:
        return _page(
          const Scaffold(
            body: SizedBox.shrink(),
          ),
        );

      case AppRoutes.settings:
        return _page(
          const Scaffold(
            body: SizedBox.shrink(),
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
