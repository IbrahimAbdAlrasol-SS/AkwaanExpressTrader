// lib/Features/auth/register/screens/user_info_tab.dart
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

class UserInfoTab extends ConsumerStatefulWidget {
  final VoidCallback? onNext;
  final void Function({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? brandImg,
    String? expectedOrders,
  }) onUserInfoChanged;
  final Map<String, dynamic> initialData;

  const UserInfoTab({
    super.key,
    this.onNext,
    required this.onUserInfoChanged,
    this.initialData = const {},
  });

  @override
  

  ConsumerState<UserInfoTab> createState() => _UserInfoTabState();
}

class _UserInfoTabState extends ConsumerState<UserInfoTab>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _brandNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus nodes
  final _fullNameFocus = FocusNode();
  final _brandNameFocus = FocusNode();
  final _userNameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // State variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  XFile? _brandImage;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;

  // Phone field enhancements
  String _selectedCountryCode = '+964';
  String _formattedPhoneNumber = '';

  // Expected orders field
  String? _expectedOrders;

  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Performance optimization
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  // ✅ BaseClient لرفع الصور
  final BaseClient _baseClient = BaseClient();

  @override
  void initState() {
    super.initState();

void _onDataChanged() {
  _saveCurrentData();
}
_fullNameController.addListener(_onDataChanged);
  _brandNameController.addListener(_onDataChanged);
  _userNameController.addListener(_onDataChanged);
  _phoneController.addListener(_onDataChanged);
  _passwordController.addListener(_onDataChanged);
  _confirmPasswordController.addListener(_onDataChanged);

    // Initialize animation controllers
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadInitialData();
    _loadSavedCountryCode();

    // Start animations
    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    // Dispose controllers
    _fullNameController.dispose();
    _brandNameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose focus nodes
    _fullNameFocus.dispose();
    _brandNameFocus.dispose();
    _userNameFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    // Dispose animation controllers
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    _scaleAnimationController.dispose();

    // Cancel debounce timer
    _debounceTimer?.cancel();

    super.dispose();
  }

  void _loadInitialData() {
    _fullNameController.text = widget.initialData['fullName'] ?? '';
    _brandNameController.text = widget.initialData['brandName'] ?? '';
    _userNameController.text = widget.initialData['userName'] ?? '';
    _phoneController.text = widget.initialData['phoneNumber'] ?? '';
    _passwordController.text = widget.initialData['password'] ?? '';
    _uploadedImageUrl = widget.initialData['brandImg'];
  }

  // دالة لحفظ رمز الدولة
  Future<void> _saveCountryCode(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country_code', countryCode);
  }

  Future<void> _loadSavedCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('selected_country_code');
    if (savedCode != null) {
      setState(() {
        _selectedCountryCode = savedCode;
      });
    }
  }

  // دالة لتنسيق الأرقام العراقية
  String _formatIraqiPhoneNumber(String phoneNumber) {
    // إزالة المسافات والرموز الإضافية
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // التحقق من الأرقام العراقية
    if (cleanNumber.startsWith('964')) {
      cleanNumber = cleanNumber.substring(3);
    }

    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }

    // تنسيق الرقم
    if (cleanNumber.length >= 10) {
      return '${cleanNumber.substring(0, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6)}';
    } else if (cleanNumber.length >= 7) {
      return '${cleanNumber.substring(0, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6)}';
    }

    return cleanNumber;
  }

  // دالة للتحقق من قوة كلمة المرور
  String? _validatePasswordStrength(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (password.length < 6) {
      return 'كلمة المرور قصيرة جداً (6 أحرف على الأقل)';
    }

    // التحقق من وجود أرقام وأحرف
    bool hasLetters = RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(password);
    bool hasNumbers = RegExp(r'[0-9]').hasMatch(password);

    if (!hasLetters && !hasNumbers) {
      return 'كلمة المرور يجب أن تحتوي على أحرف أو أرقام';
    }

    return null;
  }

  // دالة للتحقق من تطابق كلمات المرور
  bool _passwordsMatch() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  // دالة لتنسيق عرض كلمة المرور
  String _formatPasswordDisplay(String password) {
    if (password.isEmpty) return password;

    // إنشاء نمط النجوم: *** *** **
    final length = password.length;
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write('*');

      // إضافة مسافة بعد كل 3 أحرف (عدا النهاية)
      if ((i + 1) % 3 == 0 && i + 1 < length) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  // دالة لإظهار BottomSheet لاختيار الصورة
  Future<void> _showImagePickerBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(20),
            Text(
              'اختيار صورة المتجر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'التقاط صورة من الكاميرا',
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.camera);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'اختيار من المعرض',
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const Gap(20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }

  // ويدجت لخيارات مصدر الصورة
  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Gap(8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لاختيار ورفع الصورة
  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      // التحقق من الصلاحيات أولاً
      if (!mounted) return;

      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        // التحقق من وجود الملف
        final file = File(image.path);
        if (!await file.exists()) {
          throw Exception('الملف المحدد غير موجود');
        }

        // استخدام الصورة مباشرة بدون قص لتجنب الأخطاء
        CroppedFile? croppedFile;
        // تم تعطيل قص الصورة مؤقتاً لحل مشكلة التعطل
        // يمكن تفعيلها لاحقاً بعد حل مشاكل الصلاحيات
        /*
        try {
          croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'قص الصورة',
                toolbarColor: Theme.of(context).colorScheme.primary,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true,
              ),
              IOSUiSettings(
                title: 'قص الصورة',
                aspectRatioLockEnabled: true,
              ),
            ],
          );
        } catch (cropError) {
          print('خطأ في قص الصورة: $cropError');
          // استخدام الصورة الأصلية في حالة فشل القص
        }
        */

        final String imagePath;
        if (croppedFile != null) {
          imagePath = croppedFile.path;
        } else {
          imagePath = image.path;
        }

        if (!mounted) return;

        setState(() {
          _brandImage = XFile(imagePath);
          _isUploadingImage = true;
        });

        // تشغيل animation للـ fade in
        _fadeAnimationController.forward();

        try {
          final result = await _baseClient.uploadFile(imagePath);

          if (result.data != null && result.data!.isNotEmpty) {
            if (mounted) {
              setState(() {
                _uploadedImageUrl = result.data!.first;
                _isUploadingImage = false;
              });

              GlobalToast.showSuccess(
                  context: context, message: 'تم رفع الصورة بنجاح');

              _saveCurrentData();
            }
          } else {
            throw Exception('فشل في رفع الصورة إلى الخادم');
          }
        } catch (uploadError) {
          throw Exception('خطأ في رفع الصورة: ${uploadError.toString()}');
        }
      }
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');

      if (mounted) {
        setState(() {
          _isUploadingImage = false;
          _brandImage = null;
        });

        String errorMessage = 'فشل في اختيار الصورة';

        if (e.toString().contains('Permission')) {
          errorMessage = 'يرجى السماح بالوصول للكاميرا والمعرض';
        } else if (e.toString().contains('camera_access_denied')) {
          errorMessage = 'تم رفض الوصول للكاميرا';
        } else if (e.toString().contains('photo_access_denied')) {
          errorMessage = 'تم رفض الوصول للمعرض';
        } else if (e.toString().contains('الملف المحدد غير موجود')) {
          errorMessage = 'الملف المحدد غير موجود';
        } else if (e.toString().contains('خطأ في رفع الصورة')) {
          errorMessage = e.toString();
        }

        GlobalToast.show(
          context: context,
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void _saveCurrentData() {
  widget.onUserInfoChanged(
    fullName: _fullNameController.text.trim(),
    brandName: _brandNameController.text.trim(),
    userName: _userNameController.text.trim(),
    phoneNumber: _phoneController.text.trim(),
    password: _passwordController.text,
    brandImg: _uploadedImageUrl,
    expectedOrders: _expectedOrders, // هذا غير مستخدم - يمكن حذفه
  );
}

  Future<void> _handleNext() async {
    _saveCurrentData();
    if (!_formKey.currentState!.validate()) return;
    if (_uploadedImageUrl == null) {
      GlobalToast.show(
        context: context,
        message: 'يجب رفع صورة المتجر أولاً',
        backgroundColor: Colors.red,
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      GlobalToast.show(
        context: context,
        message: 'كلمة المرور غير متطابقة',
        backgroundColor: Colors.red,
      );
      return;
    }
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Store Logo Section - moved to top
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "شعار المتجر",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (_uploadedImageUrl != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ],
                  ],
                ),
                const Gap(10),
                Center(
                  child: GestureDetector(
                    onTap: _showImagePickerBottomSheet,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          width: 2,
                        ),
                        color: _uploadedImageUrl != null
                            ? Colors.transparent
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                      ),
                      child: _uploadedImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: CachedNetworkImage(
                                imageUrl: _uploadedImageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(35),
            CustomTextFormField(
              controller: _fullNameController,
              focusNode: _fullNameFocus,
              label: "أسم صاحب المتجر",
              hint: "مثال: \"محمد حسين\"",
                            suffixInner: _buildFieldStatus(_fullNameController.text.isNotEmpty),

              prefixInner: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/svg/User.svg",
                  width: 24,
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true)
                  return "اسم صاحب المتجر مطلوب";
                if (value!.trim().length < 2)
                  return "اسم صاحب المتجر قصير جداً";
                return null;
              },
              onChanged: (value) => _saveCurrentData(),
              onFieldSubmitted: (_) => _brandNameFocus.requestFocus(),
            ),
            const Gap(10),
            CustomTextFormField(
              controller: _brandNameController,
              focusNode: _brandNameFocus,
              label: "اسم المتجر",
              hint: "مثال: \"معرض الأخوين\"",
              prefixInner: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/svg/12. Storefront.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) return "اسم المتجر مطلوب";
                if (value!.trim().length < 2) return "اسم المتجر قصير جداً";
                return null;
              },
              onChanged: (value) => _saveCurrentData(),
              onFieldSubmitted: (_) => _userNameFocus.requestFocus(),
            ),
            const Gap(10),
            // حقل اسم المستخدم
            CustomTextFormField(
              controller: _userNameController,
              focusNode: _userNameFocus,
              label: "اسم المستخدم",
              hint: "مثال: \"ahmed123\"",
              prefixInner: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/svg/User.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) return "اسم المستخدم مطلوب";
                if (value!.trim().length < 3) return "اسم المستخدم قصير جداً";
                return null;
              },
              onChanged: (value) => _saveCurrentData(),
              onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
            ),
            const Gap(10),
            _buildExpectedOrdersField(),
            const Gap(10),
            // Phone field label
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "رقم هاتف المتجر",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const Gap(10),
            // Enhanced phone field with international support (copied from Login)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: IntlPhoneField(
                controller: _phoneController,
                focusNode: _phoneFocus,
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      "assets/svg/08. Phone.svg",
                      color: Theme.of(context).colorScheme.primary,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                languageCode: 'ar',
                initialCountryCode: 'IQ',
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                onChanged: (phone) {
                  setState(() {
                    _selectedCountryCode = phone.countryCode;
                    _formattedPhoneNumber = phone.completeNumber;
                  });

                  // Save country code
                  _saveCountryCode(phone.countryCode);

                  // Format Iraqi numbers
                  if (phone.countryISOCode == 'IQ') {
                    final formatted = _formatIraqiPhoneNumber(phone.number);
                    if (formatted != phone.number) {
                      _phoneController.value = _phoneController.value.copyWith(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    }
                  }
                  _saveCurrentData();
                },
                onCountryChanged: (country) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedCountryCode = '+${country.dialCode}';
                  });
                  _saveCountryCode('+${country.dialCode}');
                },
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'رقم الهاتف مطلوب';
                  }

                  // Validate Iraqi phone numbers specifically
                  if (phone.countryISOCode == 'IQ') {
                    final cleanNumber =
                        phone.number.replaceAll(RegExp(r'[^0-9]'), '');
                    if (!RegExp(r'^7[0-9]{9}$').hasMatch(cleanNumber)) {
                      return 'رقم الهاتف العراقي غير صحيح';
                    }
                  }

                  return null;
                },
                onSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
            ),
            const Gap(10),
            // Enhanced password field with animations
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: CustomTextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                label: "الرمز السري",
                hint: "أدخل كلمة المرور",
                obscureText: _obscurePassword,
                prefixInner: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    "assets/svg/09. Password.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                  _saveCurrentData();
                },
                onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
              ),
            ),
            const Gap(10),
            // Enhanced confirm password field with animations
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: CustomTextFormField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                label: "تأكيد الرمز السري",
                hint: "أعد كتابة كلمة المرور",
                obscureText: _obscureConfirmPassword,
                prefixInner: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    "assets/svg/09. Password.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                suffixInner: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    key: ValueKey(_obscureConfirmPassword),
                    onTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });

                      // Haptic feedback
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _obscureConfirmPassword
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        color: _obscureConfirmPassword
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return "تأكيد كلمة المرور مطلوب";
                  if (value != _passwordController.text) {
                    return "كلمة المرور غير متطابقة";
                  }
                  return null;
                },
                onChanged: (value) {
                  // Format password display as *** *** **
                  if (_obscureConfirmPassword && value.isNotEmpty) {
                    final formatted = _formatPasswordDisplay(value);
                    if (formatted != value) {
                      // Update display without affecting actual value
                      setState(() {});
                    }
                  }
                  _saveCurrentData();
                },
                onFieldSubmitted: (_) => _handleNext(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectedOrdersField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الطلبات اليومية المتوقعة',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
        ),
        const Gap(10),
        CustomTextFormField<String>(
          label: '',
          showLabel: false,
          hint: 'اختر عدد الطلبات المتوقعة',
          dropdownItems: [
            const DropdownMenuItem(value: '0-10', child: Text('0-10')),
            const DropdownMenuItem(value: '11-20', child: Text('11-20')),
            const DropdownMenuItem(value: '21-30', child: Text('21-30')),
            const DropdownMenuItem(value: '31-40', child: Text('31-40')),
            const DropdownMenuItem(value: '41-50', child: Text('41-50')),
          ],
          selectedValue: _expectedOrders,
          onDropdownChanged: (value) {
            setState(() {
              _expectedOrders = value;
            });
            _saveCurrentData();
          },
          suffixInner: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/svg/CaretDown.svg",
              width: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFieldStatus(bool isCompleted) {
  return Icon(
    isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
    color: isCompleted ? Colors.green : Colors.grey,
    size: 20,
  );
}
}
