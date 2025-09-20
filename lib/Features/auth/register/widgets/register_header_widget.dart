import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

/// ✅ Widget محسن لهيدر شاشة التسجيل
class RegisterHeaderWidget extends StatelessWidget {
  const RegisterHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        // ✅ Background layer with bg(3).svg
        _BackgroundLayer(),

        // ✅ Gradient overlay
        _GradientOverlay(),

        // ✅ Content layer
        _ContentLayer(),
      ],
    );
  }
}

/// ✅ Widget ثابت للخلفية مع bg(3).svg
class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SvgPicture.asset(
        'assets/svg/bg (3).svg',
        fit: BoxFit.cover,
      ),
    );
  }
}

/// ✅ Widget ثابت للتدرج اللوني
class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  static const _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A66FF),
      Color(0xFF1A66FF),
      Color(0xFFFFFFFF),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: _gradient),
      ),
    );
  }
}

/// ✅ Widget للمحتوى الرئيسي
class _ContentLayer extends StatelessWidget {
  const _ContentLayer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(30),

        // ✅ App bar section
        _AppBarSection(),

        // ✅ Logo section
        const _LogoSection(),

        // ✅ Welcome texts section
        const _WelcomeTextsSection(),
      ],
    );
  }
}

/// ✅ Widget لشريط التطبيق
class _AppBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      titleWidget: _AppBarTitle(),
      showBackButton: true,
      onBackButtonPressed: () => context.push(AppRoutes.login),
    );
  }
}

/// ✅ Widget لعنوان شريط التطبيق - تم تغييره إلى "تسجيل كتاجر"
class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "تسجيل كتاجر",
      style: context.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

/// ✅ Widget ثابت للشعار
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  static const _logoPadding = EdgeInsets.only(right: 20);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: _logoPadding,
      child: Align(
        alignment: Alignment.centerRight,
        child: _LogoWidget(),
      ),
    );
  }
}

/// ✅ Widget ثابت للشعار
class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/svg/logo-2.svg",
      width: 60,
      height: 60,
    );
  }
}

/// ✅ Widget للنصوص الترحيبية تحت الشعار
class _WelcomeTextsSection extends StatelessWidget {
  const _WelcomeTextsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20,
        left: 20,
        top: 20,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ العنوان الرئيسي
          Text(
            'إنشاء حساب جديد كتاجر',
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),

          //   const Gap(3),

          // ✅ النص التوضيحي
          Text(
            'انضم إلى شبكة أكوان أكسبريس وابدأ بإدارة وصولاتك وتتبع طلباتك بسهولة.',
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              height: 1.7,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
