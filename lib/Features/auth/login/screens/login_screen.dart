import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/Features/auth/login/widgets/login_ui_widget.dart';
import 'package:Tosell/Features/auth/login/mixins/login_state_mixin.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin, LoginStateMixin {

  late final ValueNotifier<bool> _obscurePasswordNotifier;
  late final ValueNotifier<String> _countryCodeNotifier;
  late final ValueNotifier<String> _phoneNumberNotifier;

  @override
  void initState() {
    super.initState();
        _obscurePasswordNotifier = ValueNotifier(obscurePassword);
    _countryCodeNotifier = ValueNotifier(selectedCountryCode);
    _phoneNumberNotifier = ValueNotifier(formattedPhoneNumber);
    
    initializeLoginState();
  }

  @override
  void dispose() {
    _obscurePasswordNotifier.dispose();
    _countryCodeNotifier.dispose();
    _phoneNumberNotifier.dispose();
    
    disposeLoginState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authNotifierProvider);
        
        return authState.when(
          data: (_) => child!,
          loading: () => child!,
          error: (error, stackTrace) => _ErrorWidget(error: error.toString()),
        );
      },
      child: _LoginUIWrapper(
        formKey: formKey,
        phoneController: phoneController,
        passwordController: passwordController,
        phoneFocusNode: phoneFocusNode,
        passwordFocusNode: passwordFocusNode,
        isTextFieldFocused: isTextFieldFocused,
        fadeAnimation: fadeAnimation,
        slideAnimation: slideAnimation,
        obscurePasswordNotifier: _obscurePasswordNotifier,
        countryCodeNotifier: _countryCodeNotifier,
        phoneNumberNotifier: _phoneNumberNotifier,
        onObscurePasswordToggle: _handleObscurePasswordToggle,
        onCountryCodeChanged: _handleCountryCodeChanged,
        onPhoneNumberChanged: _handlePhoneNumberChanged,
        validatePasswordStrength: validatePasswordStrength,
        formatPasswordDisplay: formatPasswordDisplay,
      ),
    );
  }

  void _handleObscurePasswordToggle() {
    _obscurePasswordNotifier.value = !_obscurePasswordNotifier.value;
    setState(() {
      obscurePassword = _obscurePasswordNotifier.value;
    });
  }

  void _handleCountryCodeChanged(String countryCode) {
    _countryCodeNotifier.value = countryCode;
    setState(() {
      selectedCountryCode = countryCode;
    });
    saveCountryCode(countryCode);
  }

  void _handlePhoneNumberChanged(String phoneNumber) {
    _phoneNumberNotifier.value = phoneNumber;
    setState(() {
      formattedPhoneNumber = phoneNumber;
    });
  }
}
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.error});
  
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class _LoginUIWrapper extends StatelessWidget {
  const _LoginUIWrapper({
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.isTextFieldFocused,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.obscurePasswordNotifier,
    required this.countryCodeNotifier,
    required this.phoneNumberNotifier,
    required this.onObscurePasswordToggle,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
    required this.validatePasswordStrength,
    required this.formatPasswordDisplay,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool isTextFieldFocused;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final ValueNotifier<bool> obscurePasswordNotifier;
  final ValueNotifier<String> countryCodeNotifier;
  final ValueNotifier<String> phoneNumberNotifier;
  final VoidCallback onObscurePasswordToggle;
  final ValueChanged<String> onCountryCodeChanged;
  final ValueChanged<String> onPhoneNumberChanged;
  final String? Function(String?) validatePasswordStrength;
  final String Function(String) formatPasswordDisplay;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscurePasswordNotifier,
      builder: (context, obscurePassword, _) {
        return ValueListenableBuilder<String>(
          valueListenable: countryCodeNotifier,
          builder: (context, selectedCountryCode, _) {
            return ValueListenableBuilder<String>(
              valueListenable: phoneNumberNotifier,
              builder: (context, formattedPhoneNumber, _) {
                return LoginUIWidget(
                  formKey: formKey,
                  phoneController: phoneController,
                  passwordController: passwordController,
                  phoneFocusNode: phoneFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  isTextFieldFocused: isTextFieldFocused,
                  obscurePassword: obscurePassword,
                  selectedCountryCode: selectedCountryCode,
                  formattedPhoneNumber: formattedPhoneNumber,
                  fadeAnimation: fadeAnimation,
                  slideAnimation: slideAnimation,
                  onObscurePasswordToggle: onObscurePasswordToggle,
                  onCountryCodeChanged: onCountryCodeChanged,
                  onPhoneNumberChanged: onPhoneNumberChanged,
                  validatePasswordStrength: validatePasswordStrength,
                  formatPasswordDisplay: formatPasswordDisplay,
                );
              },
            );
          },
        );
      },
    );
  }
}