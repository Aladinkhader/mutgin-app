import 'package:flutter/material.dart';
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x44000000),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> goldGlow = [
    BoxShadow(
      color: Color(0x33D6B56A),
      blurRadius: 20,
      spreadRadius: 1,
    ),
  ];

  static const List<BoxShadow> emeraldGlow = [
    BoxShadow(
      color: Color(0x331D6B5C),
      blurRadius: 20,
      spreadRadius: 1,
    ),
  ];
}
