import 'package:Tosell/Features/auth/register/widgets/register_sheet_widget.dart';
import 'package:Tosell/Features/auth/register/widgets/register_header_widget.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// ✅ Widget محسن لواجهة التسجيل مع نفس تصميم تسجيل الدخول
class RegisterUIWidget extends StatelessWidget {
  const RegisterUIWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _BackgroundWidget(),
            SafeArea(
              child: RegisterSheetWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Widget ثابت للخلفية - هيدر مخصص للتسجيل
class _BackgroundWidget extends StatelessWidget {
  const _BackgroundWidget();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: RegisterHeaderWidget(),
    );
  }
}
