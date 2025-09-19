import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/Features/auth/register/widgets/build_background.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Focus nodes
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  // State variables
  bool _isTextFieldFocused = false;
  bool _obscurePassword = true;
  String _selectedCountryCode = '+964'; // Default to Iraq
  String _formattedPhoneNumber = '';
  
  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Performance optimization
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Add focus listeners
    _phoneFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
    
    // Load saved country code
    _loadSavedCountryCode();
    
    // Start animations
    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  /// Handle focus changes with smooth animations
  void _handleFocusChange() {
    final isFocused = _phoneFocusNode.hasFocus || _passwordFocusNode.hasFocus;
    if (isFocused != _isTextFieldFocused) {
      setState(() {
        _isTextFieldFocused = isFocused;
      });
      
      // Animate based on focus state
      if (isFocused) {
        _fadeAnimationController.forward();
      } else {
        _fadeAnimationController.reverse();
      }
    }
  }
  
  /// Load saved country code from SharedPreferences
  Future<void> _loadSavedCountryCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString('last_country_code');
      if (savedCode != null && mounted) {
        setState(() {
          _selectedCountryCode = savedCode;
        });
      }
    } catch (e) {
      // Handle error silently, use default country code
    }
  }
  
  /// Save country code to SharedPreferences
  Future<void> _saveCountryCode(String countryCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_country_code', countryCode);
    } catch (e) {
      // Handle error silently
    }
  }
  

  

  
  /// Validate password strength
  String? _validatePasswordStrength(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (password.length < 6) {
      return 'كلمة المرور قصيرة جداً (6 أحرف على الأقل)';
    }
    
    // Check for at least one letter and one number
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
  String _formatPasswordDisplay(String password) {
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

  @override
  void dispose() {
    // Dispose controllers
    _phoneController.dispose();
    _passwordController.dispose();
    
    // Dispose focus nodes
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    
    // Dispose animation controllers
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);

    return loginState.when(
      data: (_) => _buildUi(context, loginState),
      loading: () => _buildUi(context, loginState),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  Widget _buildUi(BuildContext context, AsyncValue<void> loginState) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/svg/bg (3).svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF1A66FF),
                                Color(0xFF1A66FF),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(30),
                          CustomAppBar(
                            // title: "إنشاء حساب",
                            titleWidget: Text(
                            "تسجيل دخول",
                              style: context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            showBackButton: true,
                            onBackButtonPressed: () =>
                                context.push(AppRoutes.registerScreen),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SvgPicture.asset(
                                "assets/svg/logo-2.svg",
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                         
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            DraggableScrollableSheet(
              initialChildSize: 0.76,
              minChildSize: 0.76,
              maxChildSize: 0.76,
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
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: AppSpaces.horizontalMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(AppSpaces.medium),
                            if (!_isTextFieldFocused)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "مرحبًا بعودتك! 👋",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                   " أدخل رقم هاتفك وكلمة السر للمتابعة وإدارة وصولاتك بسهولة.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  const Gap(AppSpaces.medium),
                                ],
                              ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Phone field label
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "رقم الهاتف",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  // Enhanced phone field with international support
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                                      ),
                                    ),
                                    child: IntlPhoneField(
                                      controller: _phoneController,
                                      focusNode: _phoneFocusNode,
                                      showCountryFlag: true,
                                      showDropdownIcon: true,
                                      
                                      disableLengthCheck: true,
                                      decoration: InputDecoration(
                                        hintText: '07xx xxx xxx',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(27),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
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
                                        setState(() {
                                          _selectedCountryCode = phone.countryCode;
                                          _formattedPhoneNumber = phone.completeNumber;
                                        });
                                        
                                        // Save country code
                                        _saveCountryCode(phone.countryCode);
                                        

                                      },
                                      onCountryChanged: (country) {
                                        setState(() {
                                          _selectedCountryCode = '+${country.dialCode}';
                                        });
                                        _saveCountryCode('+${country.dialCode}');
                                      },
                                      validator: null,
                                    ),
                                  ),
                                  const Gap(AppSpaces.medium),
                                  // Enhanced password field with show/hide toggle
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    child: CustomTextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      focusNode: _passwordFocusNode,
                                      label: "كلمة المرور",
                                       hint: '******',
                                       
                                      fillColor: Colors.grey.shade50,
                                      validator: _validatePasswordStrength,
                                      onChanged: (value) {
                                        // Format password display as *** *** **
                                        if (_obscurePassword && value.isNotEmpty) {
                                          final formatted = _formatPasswordDisplay(value);
                                          if (formatted != value) {
                                            // Update display without affecting actual value
                                            setState(() {});
                                          }
                                        }
                                      },
                                      prefixInner: Icon(
                                        CupertinoIcons.lock,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      suffixInner: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        child: GestureDetector(
                                          key: ValueKey(_obscurePassword),
                                          onTap: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                            
                                            // Haptic feedback
                                            HapticFeedback.lightImpact();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(
                                              _obscurePassword
                                                  ? CupertinoIcons.eye_slash
                                                  : CupertinoIcons.eye,
                                              color: _obscurePassword
                                                  ? Colors.grey
                                                  : Theme.of(context).colorScheme.primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(AppSpaces.small),
                                  // إضافة رابط "نسيت كلمة المرور؟" أسفل حقل كلمة المرور
                                  Align(
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
                                  ),
                                ],
                              ),
                            ),
                            
                            // مساحة إضافية لتجنب اختفاء المحتوى تحت الأزرار الثابتة
                            const Gap(100),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        // الأزرار الثابتة في الأسفل
        bottomNavigationBar: Container(
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final phoneNumber = _phoneController.text;
                    final password = _passwordController.text;

                    final result = await ref
                        .read(authNotifierProvider.notifier)
                        .login(
                            passWord: password,
                            phonNumber: phoneNumber);

                    if (result.$1 == null) {
                      GlobalToast.show(
                        context: context,
                        message: result.$2!,
                        backgroundColor:
                            Theme.of(context).colorScheme.error,
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
                },
              ),
              
              const Gap(16),
              
              // نص "ليس لديك حساب؟ إنشاء حساب"
              Row(
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
                    onTap: () {
                      context.go(AppRoutes.registerScreen);
                    },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}