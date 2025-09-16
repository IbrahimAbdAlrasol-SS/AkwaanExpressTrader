import 'package:flutter/material.dart';

class SupportStatus {
  final String name;
  final Color color;
  final Color textColor;
  final Color darkColor;
  final Color darkTextColor;

  SupportStatus({
    required this.name,
    required this.color,
    required this.textColor,
    required this.darkColor,
    required this.darkTextColor,
  });

  Color getBackgroundColor(bool isDarkTheme) {
    return isDarkTheme ? darkColor : color;
  }

  Color getTextColor(bool isDarkTheme) {
    return isDarkTheme ? darkTextColor : textColor;
  }

  static final List<SupportStatus> values = [
    SupportStatus(
      name: 'قيد المراجعة',
      color: const Color(0xFFFFFAE5),
      textColor: const Color(0xFF524100),
      darkColor: const Color(0xFF3D3000),
      darkTextColor: const Color(0xFFFFE082),
    ),
    SupportStatus(
      name: 'قيد الحل',
      color: const Color(0xFFFFF5F5),
      textColor: const Color(0xFF520000),
      darkColor: const Color(0xFF3D0000),
      darkTextColor: const Color(0xFFFFCDD2),
    ),
    SupportStatus(
      name: 'مغلقة',
      color: const Color(0xFFE5FFE5),
      textColor: const Color(0xFF005200),
      darkColor: const Color(0xFF003D00),
      darkTextColor: const Color(0xFFC8E6C9),
    ),
  ];
}
