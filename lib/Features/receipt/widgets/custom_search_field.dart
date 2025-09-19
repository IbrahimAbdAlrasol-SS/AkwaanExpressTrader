import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  const CustomSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Border Radius/large
        border: Border.all(
          color: const Color(0xFFF0F0F0),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.w300, // Light
          fontSize: 16,
          height: 1.5, // line-height: 24px / font-size: 16px = 1.5
          letterSpacing: 0,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن رقم وصل، رقم هاتف، اسم زبون',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search,
              size: 24,
              color: Colors.grey.shade600,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(
            top: 12,
            bottom: 8,
            left: 16,
            right: 16,
          ),
        ),
      ),
    );
  }
}
