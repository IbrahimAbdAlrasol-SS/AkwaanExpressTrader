import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mixin محسن للأداء يحتوي على المتغيرات والدوال المشتركة لصفحة تسجيل الدخول
mixin LoginStateMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  // Controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Focus nodes
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // State variables
  bool isTextFieldFocused = false;
  bool obscurePassword = true;
  String selectedCountryCode = '+964'; // Default to Iraq
  String formattedPhoneNumber = '';

  late AnimationController _mainAnimationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  SharedPreferences? _prefsCache;

  // Performance optimization
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration _animationDuration = Duration(milliseconds: 350);

  void initializeLoginState() {
    _mainAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    // ✅ تحسين: animations مع intervals لتوفير الذاكرة
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    // Add focus listeners
    phoneFocusNode.addListener(handleFocusChange);
    passwordFocusNode.addListener(handleFocusChange);

    // ✅ تحسين: تحميل async بدون انتظار
    _initializeAsync();

    // Start animations
    _mainAnimationController.forward();
  }

  void _initializeAsync() {
    loadSavedCountryCode();
  }

  void handleFocusChange() {
    final isFocused = phoneFocusNode.hasFocus || passwordFocusNode.hasFocus;
    if (isFocused != isTextFieldFocused) {
      setState(() {
        isTextFieldFocused = isFocused;
      });

      // ✅ تحسين: استخدام animation controller واحد
      if (isFocused) {
        _mainAnimationController.forward();
      } else {
        _mainAnimationController.reverse();
      }
    }
  }

  Future<void> loadSavedCountryCode() async {
    try {
      _prefsCache ??= await SharedPreferences.getInstance();
      final savedCode = _prefsCache!.getString('last_country_code');

      if (savedCode != null && mounted) {
        setState(() {
          selectedCountryCode = savedCode;
        });
      }
    } catch (e) {
      if (kDebugMode) print('خطأ في تحميل country code: $e');
    }
  }

  Future<void> saveCountryCode(String countryCode) async {
    try {
      _prefsCache ??= await SharedPreferences.getInstance();
      await _prefsCache!.setString('last_country_code', countryCode);
      if (mounted) {
        setState(() {
          selectedCountryCode = countryCode;
        });
      }
    } catch (e) {
      if (kDebugMode) print('خطأ في حفظ country code: $e');
    }
  }

  String? validatePasswordStrength(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (password.length < 6) {
      return 'كلمة المرور قصيرة جداً (6 أحرف على الأقل)';
    }

    final hasLetter = RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    if (!hasLetter) {
      return 'كلمة المرور يجب أن تحتوي على أحرف';
    }

    if (!hasNumber) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }

    return null;
  }

  /// Format password display as *** *** **
  String formatPasswordDisplay(String password) {
    if (password.isEmpty) return password;

    // Create asterisks pattern: *** *** **
    final length = password.length;
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write('*');

      // Add space after every 3 characters (except at the end)
      if ((i + 1) % 3 == 0 && i + 1 < length) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  /// ✅ تنظيف محسن للموارد
  void disposeLoginState() {
    // Dispose controllers
    phoneController.dispose();
    passwordController.dispose();

    // Dispose focus nodes
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();

    // ✅ تحسين: dispose animation controller واحد فقط
    _mainAnimationController.dispose();

    // ✅ تنظيف cache (لا نحتاج dispose للـ SharedPreferences)
    _prefsCache = null;
  }
}
