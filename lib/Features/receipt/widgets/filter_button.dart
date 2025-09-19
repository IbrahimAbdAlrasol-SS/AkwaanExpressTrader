import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FilterButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Border Radius/large
        border: Border.all(
          color: const Color(0xFFF0F0F0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Icon(
              Icons.tune, // أيقونة الفلتر
              size: 24,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }
}
