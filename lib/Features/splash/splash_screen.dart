import 'dart:async';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _topCircleOffset;
  late Animation<Offset> _bottomCircleOffset;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _topCircleOffset = Tween<Offset>(
      begin: const Offset(-1.5, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _bottomCircleOffset = Tween<Offset>(
      begin: const Offset(1.5, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();


    _checkAuthStatus();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildCircle({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(24, 55, 38, 82),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: Stack(
        children: [
          // Background SVG
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg/bg (3).svg',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
           Positioned.fill(
             child: Container(
               decoration: const BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter,
                   colors: [
                     Color(0x801D80FF), // #1D80FF with 50% opacity
                     Color(0x807D1A00), // #7D1A00 with 50% opacity
                   ],
                 ),
               ),
             ),
           ),
          // Logo
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                'assets/svg/logo-2.svg',
                width: size.width * 0.5,
                height: size.height * 0.3,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = await SharedPreferencesHelper.getUser();

    if (user == null) {
      // غير مسجل دخول
      if (mounted) context.go(AppRoutes.login);
      return;
    }

    // الحساب مفعل
    if (mounted) context.go(AppRoutes.home);
  }
}


