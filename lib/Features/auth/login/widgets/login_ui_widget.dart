import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../app/app.dart';
import 'login_header_widget.dart';
import 'login_welcome_widget.dart';
import 'login_form_widget.dart';

/// ✅ Widget محسن لواجهة تسجيل الدخول مع تقليل إعادة البناء
class LoginUIWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool isTextFieldFocused;
  final bool obscurePassword;
  final String selectedCountryCode;
  final String formattedPhoneNumber;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onObscurePasswordToggle;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged;
  final String? Function(String?) validatePasswordStrength;
  final String Function(String) formatPasswordDisplay;

  const LoginUIWidget({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.isTextFieldFocused,
    required this.obscurePassword,
    required this.selectedCountryCode,
    required this.formattedPhoneNumber,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onObscurePasswordToggle,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
    required this.validatePasswordStrength,
    required this.formatPasswordDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false, // تغيير إلى false لمنع التداخل
        body: Stack(
          children: [
            // ✅ Background ثابت - يصل إلى أعلى الشاشة
            const _BackgroundWidget(),
            
            // ✅ المحتوى القابل للتمرير مع SafeArea
            SafeArea(
              child: _ScrollableContentWidget(
                formKey: formKey,
                phoneController: phoneController,
                passwordController: passwordController,
                phoneFocusNode: phoneFocusNode,
                passwordFocusNode: passwordFocusNode,
                isTextFieldFocused: isTextFieldFocused,
                obscurePassword: obscurePassword,
                onCountryCodeChanged: onCountryCodeChanged,
                onPhoneNumberChanged: onPhoneNumberChanged,
                onObscurePasswordToggle: onObscurePasswordToggle,
                validatePasswordStrength: validatePasswordStrength,
                formatPasswordDisplay: formatPasswordDisplay,
              ),
            ),
          ],
        ),
        // ✅ الأزرار الثابتة في الأسفل
        bottomNavigationBar: SafeArea(
          child: _BottomActionsWidget(
            formKey: formKey,
            phoneController: phoneController,
            passwordController: passwordController,
          ),
        ),
      ),
    );
  }
}

/// ✅ Widget ثابت للخلفية
class _BackgroundWidget extends StatelessWidget {
  const _BackgroundWidget();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: LoginHeaderWidget(),
    );
  }
}
class _ScrollableContentWidget extends StatelessWidget {
  const _ScrollableContentWidget({
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.isTextFieldFocused,
    required this.obscurePassword,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
    required this.onObscurePasswordToggle,
    required this.validatePasswordStrength,
    required this.formatPasswordDisplay,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool isTextFieldFocused;
  final bool obscurePassword;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged;
  final VoidCallback onObscurePasswordToggle;
  final String? Function(String?) validatePasswordStrength;
  final String Function(String) formatPasswordDisplay;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;
    
    // حساب الحجم المناسب بناءً على حالة لوحة المفاتيح
    double calculateChildSize() {
      if (keyboardHeight > 0) {
        // عندما تكون لوحة المفاتيح مفتوحة، نقلل الحجم
        return 0.5;
      } else {
        // عندما تكون لوحة المفاتيح مغلقة
        return 0.76;
      }
    }
    
    final childSize = calculateChildSize();
    
    return DraggableScrollableSheet(
      initialChildSize: childSize,
      minChildSize: keyboardHeight > 0 ? 0.3 : 0.5,
      maxChildSize: keyboardHeight > 0 ? 0.8 : 0.9,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppSpaces.exLarge),
                topLeft: Radius.circular(AppSpaces.exLarge),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppSpaces.exLarge),
                topLeft: Radius.circular(AppSpaces.exLarge),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.3,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpaces.medium,
                      right: AppSpaces.medium,
                      bottom: keyboardHeight > 0 ? 20 : 100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(AppSpaces.medium),
                        if (!isTextFieldFocused && keyboardHeight == 0)
                          const LoginWelcomeWidget(),
                        Form(
                          key: formKey,
                          child: LoginFormWidget(
                            phoneController: phoneController,
                            passwordController: passwordController,
                            phoneFocusNode: phoneFocusNode,
                            passwordFocusNode: passwordFocusNode,
                            obscurePassword: obscurePassword,
                            onCountryCodeChanged: onCountryCodeChanged,
                            onPhoneNumberChanged: onPhoneNumberChanged,
                            onObscurePasswordToggle: onObscurePasswordToggle,
                            validatePasswordStrength: validatePasswordStrength,
                            formatPasswordDisplay: formatPasswordDisplay,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ✅ Widget للأزرار السفلية مع Consumer منفصل
class _BottomActionsWidget extends ConsumerWidget {
  const _BottomActionsWidget({
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(authNotifierProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewPadding.bottom + 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر تسجيل الدخول
          FillButton(
            label: "تسجيل الدخول",
            isLoading: loginState.isLoading,
            onPressed: () => _handleLogin(context, ref),
          ),
          
          const Gap(16),
          
          // نص "ليس لديك حساب؟ إنشاء حساب"
          const _SignUpPromptWidget(),
        ],
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      final phoneNumber = phoneController.text;
      final password = passwordController.text;

      final result = await ref
          .read(authNotifierProvider.notifier)
          .login(
              password: password,
              phoneNumber: phoneNumber);

      if (!context.mounted) return;

      if (result.$1 == null) {
        GlobalToast.show(
          context: context,
          message: result.$2!,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
        );
      } else {
        GlobalToast.show(
          context: context,
          message: "تم تسجيل الدخول بنجاح",
          backgroundColor: context.colorScheme.primary,
          textColor: Colors.white,
        );
        SharedPreferencesHelper.saveUser(result.$1!);
        context.go(AppRoutes.home);
      }
    }
  }
}

/// ✅ Widget ثابت لنص التسجيل
class _SignUpPromptWidget extends StatelessWidget {
  const _SignUpPromptWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ليس لديك حساب؟",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 14,
          ),
        ),
        const Gap(AppSpaces.exSmall),
        GestureDetector(
          onTap: () => context.go(AppRoutes.registerScreen),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Text(
              "إنشاء حساب",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}