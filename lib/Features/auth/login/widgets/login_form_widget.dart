import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

/// ✅ Widget محسن لنموذج تسجيل الدخول مع تقليل إعادة البناء
class LoginFormWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged;
  final VoidCallback onObscurePasswordToggle;
  final String? Function(String?)? validatePasswordStrength;
  final String Function(String) formatPasswordDisplay;

  const LoginFormWidget({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
    required this.onObscurePasswordToggle,
    required this.validatePasswordStrength,
    required this.formatPasswordDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Phone field section
        _PhoneFieldSection(
          phoneController: phoneController,
          phoneFocusNode: phoneFocusNode,
          onCountryCodeChanged: onCountryCodeChanged,
          onPhoneNumberChanged: onPhoneNumberChanged,
        ),
        
        const Gap(AppSpaces.medium),
        
        // ✅ Password field section
        _PasswordFieldSection(
          passwordController: passwordController,
          passwordFocusNode: passwordFocusNode,
          obscurePassword: obscurePassword,
          onObscurePasswordToggle: onObscurePasswordToggle,
          validatePasswordStrength: validatePasswordStrength,
          formatPasswordDisplay: formatPasswordDisplay,
        ),
        
        const Gap(AppSpaces.small),
        
        // ✅ Forgot password link
        const _ForgotPasswordWidget(),
      ],
    );
  }
}

/// ✅ Widget منفصل لحقل رقم الهاتف
class _PhoneFieldSection extends StatelessWidget {
  const _PhoneFieldSection({
    required this.phoneController,
    required this.phoneFocusNode,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
  });

  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(text: "رقم الهاتف"),
        const Gap(8),
        _PhoneInputField(
          phoneController: phoneController,
          phoneFocusNode: phoneFocusNode,
          onCountryCodeChanged: onCountryCodeChanged,
          onPhoneNumberChanged: onPhoneNumberChanged,
        ),
      ],
    );
  }
}

/// ✅ Widget منفصل لحقل كلمة المرور
class _PasswordFieldSection extends StatelessWidget {
  const _PasswordFieldSection({
    required this.passwordController,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.onObscurePasswordToggle,
    required this.validatePasswordStrength,
    required this.formatPasswordDisplay,
  });

  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final VoidCallback onObscurePasswordToggle;
  final String? Function(String?)? validatePasswordStrength;
  final String Function(String) formatPasswordDisplay;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // تقليل مدة الانيميشن
      curve: Curves.easeOut, // تغيير منحنى الانيميشن
      child: CustomTextFormField(
        controller: passwordController,
        obscureText: obscurePassword,
        focusNode: passwordFocusNode,
        label: "كلمة المرور",
        hint: '******',
        fillColor: Colors.grey.shade50,
        validator: validatePasswordStrength,

        onChanged: (value) {
          // Format password display as *** *** **
          if (obscurePassword && value.isNotEmpty) {
            final formatted = formatPasswordDisplay(value);
            if (formatted != value) {
              // Update display without affecting actual value
            }
          }
        },
        prefixInner: Icon(
          CupertinoIcons.lock,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixInner: _PasswordToggleButton(
          obscurePassword: obscurePassword,
          onToggle: onObscurePasswordToggle,
        ),
      ),
    );
  }
}

/// ✅ Widget ثابت لتسميات الحقول
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// ✅ Widget محسن لحقل الهاتف
class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField({
    required this.phoneController,
    required this.phoneFocusNode,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
  });

  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged;

  static const _borderRadius = 27.0;
  static const _contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // منع التفاعلات المتكررة السريعة
        FocusScope.of(context).requestFocus(phoneFocusNode);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: IntlPhoneField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          showCountryFlag: true,
          showDropdownIcon: true,
          disableLengthCheck: true,
          decoration: InputDecoration(
            hintText: '07xx xxx xxx',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: _contentPadding,
            prefixIcon: Icon(
              CupertinoIcons.phone,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          languageCode: 'ar',
          initialCountryCode: 'IQ',
          textAlign: TextAlign.right,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          
          onChanged: (phone) {
            onCountryCodeChanged(phone.countryCode);
            onPhoneNumberChanged(phone.completeNumber);
          },
          onCountryChanged: (country) {
            onCountryCodeChanged('+${country.dialCode}');
          },
          validator: null,
        ),
      ),
    );
  }
}

/// ✅ Widget محسن لزر إظهار/إخفاء كلمة المرور
class _PasswordToggleButton extends StatelessWidget {
  const _PasswordToggleButton({
    required this.obscurePassword,
    required this.onToggle,
  });

  final bool obscurePassword;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        key: ValueKey(obscurePassword),
        onTap: () {
          onToggle();
          HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
            color: obscurePassword
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// ✅ Widget ثابت لرابط "نسيت كلمة المرور؟"
class _ForgotPasswordWidget extends StatelessWidget {
  const _ForgotPasswordWidget();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // التوجه إلى صفحة إعادة تعيين كلمة المرور
          //context.push(AppRoutes.resetPasswordScreen);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Text(
            "نسيت كلمة المرور؟",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}