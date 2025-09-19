import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// ✅ Widget محسن لرسالة الترحيب في صفحة تسجيل الدخول
class LoginWelcomeWidget extends StatelessWidget {
  const LoginWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Welcome title
        _WelcomeTitle(),

        Gap(8),

        // ✅ Welcome description
        _WelcomeDescription(),

        Gap(AppSpaces.medium),
      ],
    );
  }
}

/// ✅ Widget ثابت لعنوان الترحيب
class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle();

  static const _welcomeText = "مرحبًا بعودتك! 👋";

  @override
  Widget build(BuildContext context) {
    return Text(
      _welcomeText,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// ✅ Widget ثابت لوصف الترحيب
class _WelcomeDescription extends StatelessWidget {
  const _WelcomeDescription();

  static const _descriptionText =
      " أدخل رقم هاتفك وكلمة السر للمتابعة وإدارة وصولاتك بسهولة.";

  @override
  Widget build(BuildContext context) {
    return Text(
      _descriptionText,
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
