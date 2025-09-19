import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        // ✅ Background layer
        _BackgroundLayer(),

        // ✅ Gradient overlay
        _GradientOverlay(),

        // ✅ Content layer
        _ContentLayer(),
      ],
    );
  }
}

/// ✅ Widget ثابت للخلفية
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
    ],
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
      onBackButtonPressed: () => context.push(AppRoutes.registerScreen),
    );
  }
}

/// ✅ Widget لعنوان شريط التطبيق
class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "تسجيل دخول",
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
