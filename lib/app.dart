import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class MutqinApp extends StatelessWidget {
  const MutqinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'متقن',
      theme: AppTheme.dark(),
      home: const Scaffold(
        body: Center(
          child: Text(
            'متقن',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
