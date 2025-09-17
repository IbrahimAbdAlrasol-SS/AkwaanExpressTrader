import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/Features/auth/register/screens/user_info_tab.dart';
import 'package:Tosell/Features/auth/register/widgets/build_background.dart';
import 'package:Tosell/Features/auth/register/screens/delivery_info_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentIndex = 0;
  bool _isSubmitting = false;

  String? fullName;
  String? brandName;
  String? userName;
  String? phoneNumber;
  String? password;
  String? brandImg;
  String? expectedOrders;

  List<Zone> selectedZones = [];
  double? latitude;
  double? longitude;
  String? nearestLandmark;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // تهيئة Animation Controllers
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // تهيئة Animations
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

    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
        // تشغيل animation عند تغيير التاب
        _slideAnimationController.reset();
        _slideAnimationController.forward();
      }
    });

    // بدء التأثيرات البصرية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeAnimationController.forward();
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _goToNextTab() {
    if (_currentIndex < _tabController.length - 1) {
      if (_validateAndShowErrors()) {
        _tabController.animateTo(_currentIndex + 1);
      }
    }
  }

  bool _validateAndShowErrors() {
    // السماح بالانتقال دائماً
    return true;
  }

  // دالة للتحقق من البيانات بدون إظهار التحذيرات
  bool _isDataComplete() {
    // زر التالي مفعل دائماً
    return true;
  }

  bool _canNavigateToNextTab() {
    return _isDataComplete();
  }

  void _updateUserInfo({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? brandImg,
    String? expectedOrders,
  }) {
    setState(() {
      if (fullName != null) this.fullName = fullName;
      if (brandName != null) this.brandName = brandName;
      if (userName != null) this.userName = userName;
      if (phoneNumber != null) this.phoneNumber = phoneNumber;
      if (password != null) this.password = password;
      if (brandImg != null) this.brandImg = brandImg;
      if (expectedOrders != null) this.expectedOrders = expectedOrders;
    });
  }

  /// ✅ تحديث المناطق والإحداثيات من DeliveryInfoTab
  void _updateZonesWithLocation({
    required List<Zone> zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) {
    setState(() {
      selectedZones = zones;
      this.latitude = latitude;
      this.longitude = longitude;
      this.nearestLandmark = nearestLandmark;
    });
  }

  bool _validateData() {
    if (fullName?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'اسم صاحب المتجر مطلوب',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (brandName?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'اسم المتجر مطلوب',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (userName?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'اسم المستخدم مطلوب',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (phoneNumber?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'رقم الهاتف مطلوب',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (password?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'كلمة المرور مطلوبة',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (brandImg?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'صورة المتجر مطلوبة',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (selectedZones.isEmpty) {
      GlobalToast.show(
          context: context,
          message: 'يجب إضافة منطقة واحدة على الأقل',
          backgroundColor: Colors.red);
      _tabController.animateTo(1);
      return false;
    }

    return true;
  }

  Future<void> _submitRegistration() async {
    if (!_validateData()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref.read(authNotifierProvider.notifier).register(
            fullName: fullName!,
            brandName: brandName!,
            userName: userName!,
            phoneNumber: phoneNumber!,
            password: password!,
            brandImg: brandImg!,
            zones: selectedZones,
            latitude: latitude,
            longitude: longitude,
            nearestLandmark: nearestLandmark,
          );

      if (result.$1 != null) {
        // ✅ حالة مثالية: تم التسجيل والحصول على بيانات المستخدم مباشرة
        await SharedPreferencesHelper.saveUser(result.$1!);

        GlobalToast.showSuccess(
          context: context,
          message: 'مرحباً بك في توصيل! تم تفعيل حسابك بنجاح',
          durationInSeconds: 3,
        );

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          context.go(AppRoutes.home);
        }
      } else if (result.$2 == "REGISTRATION_SUCCESS_PENDING_APPROVAL") {
        // ✅ تم التسجيل بنجاح ولكن في انتظار الموافقة
        GlobalToast.showSuccess(
          context: context,
          message: 'تم التسجيل بنجاح! سيتم مراجعة طلبك والموافقة عليه قريباً',
          durationInSeconds: 4,
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          context.go(AppRoutes.login);
        }
      } else {
        // ❌ خطأ حقيقي في التسجيل
        print('❌ فشل التسجيل: ${result.$2}');
        GlobalToast.show(
          context: context,
          message: result.$2 ?? 'فشل في التسجيل',
          backgroundColor: Colors.red,
          durationInSeconds: 4,
        );
      }
    } catch (e) {
      GlobalToast.show(
        context: context,
        message: 'خطأ في التسجيل: ${e.toString()}',
        backgroundColor: Colors.red,
        durationInSeconds: 4,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (fullName?.isNotEmpty == true ||
        brandName?.isNotEmpty == true ||
        userName?.isNotEmpty == true ||
        phoneNumber?.isNotEmpty == true ||
        brandImg?.isNotEmpty == true ||
        selectedZones.isNotEmpty) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'تأكيد الخروج',
                style: TextStyle(fontFamily: "Tajawal"),
              ),
              content: const Text(
                'سيتم فقدان جميع البيانات المدخلة. هل تريد الخروج؟',
                style: TextStyle(fontFamily: "Tajawal"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء',
                      style: TextStyle(fontFamily: "Tajawal")),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('خروج',
                      style: TextStyle(fontFamily: "Tajawal")),
                ),
              ],
            ),
          ) ??
          false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              _buildBackgroundSection(),
              _buildBottomSheetSection(),
              if (_isSubmitting)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        Gap(16),
                        Text(
                          'جاري إنشاء الحساب...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Tajawal",
                          ),
                        ),
                        Gap(8),
                        Text(
                          'يرجى الانتظار لحظات',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: "Tajawal",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomButtons(),
      ),
    );
  }

  Widget _buildBackgroundSection() {
    return Column(
      children: [
        Expanded(
          child: buildBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                CustomAppBar(
                  titleWidget: Text(
                    'تسجيل دخول',
                    style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  showBackButton: true,
                  onBackButtonPressed: () async {
                    final shouldPop = await _onWillPop();
                    if (shouldPop && mounted) {
                      context.push(AppRoutes.login);
                    }
                  },
                ),
                _buildLogo(),
                const Gap(10),
                _buildTitle(),
                const Gap(10),
                _buildDescription(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SvgPicture.asset(
        "assets/svg/logo-2.svg",
        width: 60,
        height: 60,
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        " إنشاء حساب جديد كتاجر",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        " انضم إلى شبكة أكوان أكسبريس وابدأ بإدارة وصولاتك وتتبع طلباتك بسهولة.",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomSheetSection() {
    return DraggableScrollableSheet(
      initialChildSize: 0.67,
      minChildSize: 0.67,
      maxChildSize: 0.67,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTabBar(),
              Expanded(
                child: _buildTabBarView(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: IgnorePointer(
            child: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                indicator: const BoxDecoration(),
                labelPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
              tabs: List.generate(2, (i) {
                final bool isSelected = _currentIndex == i;
                final bool isCompleted = _currentIndex > i;
                final bool isDisabled = i == 1 && _currentIndex == 0 && !_canNavigateToNextTab();
                final String label =
                    i == 0 ? "معلومات الحساب" : "معلومات التوصيل";

                return Tab(
                  child: Opacity(
                    opacity: isDisabled ? 0.5 : 1.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 8,
                          width: 160.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : isCompleted
                                    ? const Color(0xff8CD98C)
                                    : const Color(0xffE1E7EA),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const Gap(5),
                        Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : isCompleted
                                    ? const Color(0xff8CD98C)
                                    : Theme.of(context).colorScheme.secondary,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const Gap(10),
    
    ]);
  }

  Widget _buildBottomButtons() {
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
      child: _currentIndex == 0
          ? _buildFirstTabButtons()
          : _buildSecondTabButtons(),
    );
  }

  Widget _buildFirstTabButtons() {
    final bool canProceed = _canNavigateToNextTab();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 150,
            height: 50,
            child: FilledButton(
              onPressed: canProceed ? _goToNextTab : null,
              style: FilledButton.styleFrom(
                backgroundColor: canProceed 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[400],
              ),
              child: const Text('التالي'),
            ),
          ),
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "هل لديك حساب؟",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const Gap(5),
            GestureDetector(
              onTap: () => context.go(AppRoutes.login),
              child: Text(
                "تسجيل الدخول",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondTabButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSubmitting ? null : () => _tabController.animateTo(0),
            child: const Text('السابق'),
          ),
        ),
        const Gap(16),
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: _isSubmitting ? null : _submitRegistration,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('إنشاء الحساب'),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // التاب الأول مع التأثيرات البصرية
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: UserInfoTab(
                      onNext: _goToNextTab,
                      onUserInfoChanged: _updateUserInfo,
                      initialData: {
                        'fullName': fullName,
                        'brandName': brandName,
                        'userName': userName,
                        'phoneNumber': phoneNumber,
                        'password': password,
                        'brandImg': brandImg,
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // التاب الثاني مع التأثيرات البصرية
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: DeliveryInfoTab(
                      onZonesChangedWithLocation: _updateZonesWithLocation,
                      initialZones: selectedZones,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
