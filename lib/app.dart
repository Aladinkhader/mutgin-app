import 'package:flutter/material.dart';

class MutqinApp extends StatelessWidget {
  const MutqinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'متقن',
      home: const Scaffold(
        body: Center(
          child: Text('متقن'),
        ),
      ),
    );
  }
}
