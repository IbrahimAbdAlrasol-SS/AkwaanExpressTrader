import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildBackground({Widget? child, double height = 360}) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A66FF), // بنفسجي داكن
              Color(0xFF1A66FF), // بنفسجي فاتح
            ],
            begin: Alignment.topCenter, // التدرج من الأعلى
            end: Alignment.bottomCenter, // إلى الأسفل
            //stops: [0.0, 0.8], // توزيع التدرج (اختياري)
          ),
        ),
      ),
      if (child != null) child
    ],
  );
}

Positioned buildCircle({
  double? bottom,
  double? left,
  double? right,
  double? top,
  double? circleWidth = 400,
  double? circleHeight = 320,
  bool isFirstCircle = true, // إضافة معامل لتحديد اللون
}) {
  return Positioned(
    bottom: bottom,
    left: left,
    right: right,
    top: top,
    child: Container(
      width: circleWidth,
      height: circleHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFirstCircle
            ? const Color.fromARGB(24, 55, 38, 82)
            : const Color.fromARGB(32, 110, 76, 61),
      ),
    ),
  );
}
