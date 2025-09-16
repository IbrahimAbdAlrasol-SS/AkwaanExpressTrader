import 'package:Tosell/core/Model/profile/zone.dart';
import 'package:Tosell/core/Services/_auth/auth_service.dart';
import 'package:Tosell/core/Services/profile/zone_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Model/auth/User.dart';

part 'registration_provider.g.dart';

class RegistrationState {
  final String? fullName;
  final String? brandName;
  final String? userName;
  final String? phoneNumber;
  final String? password;
  final String? confirmPassword;

  // الصورة
  final XFile? brandImage;
  final String? uploadedImageUrl;
  final bool isUploadingImage;

  // المناطق
  final List<RegistrationZoneInfo> zones;
  final List<Zone> availableZones;
  final bool isLoadingZones;

  // حالة التسجيل
  final bool isSubmitting;
  final String? error;
  final User? registeredUser;

  const RegistrationState({
    this.fullName,
    this.brandName,
    this.userName,
    this.phoneNumber,
    this.password,
    this.confirmPassword,
    this.brandImage,
    this.uploadedImageUrl,
    this.isUploadingImage = false,
    this.zones = const [],
    this.availableZones = const [],
    this.isLoadingZones = false,
    this.isSubmitting = false,
    this.error,
    this.registeredUser,
  });

  RegistrationState copyWith({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    XFile? brandImage,
    String? uploadedImageUrl,
    bool? isUploadingImage,
    List<RegistrationZoneInfo>? zones,
    List<Zone>? availableZones,
    bool? isLoadingZones,
    bool? isSubmitting,
    String? error,
    User? registeredUser,
    int? type,
  }) {
    return RegistrationState(
      fullName: fullName ?? this.fullName,
      brandName: brandName ?? this.brandName,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      brandImage: brandImage ?? this.brandImage,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      zones: zones ?? this.zones,
      availableZones: availableZones ?? this.availableZones,
      isLoadingZones: isLoadingZones ?? this.isLoadingZones,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error ?? this.error,
      registeredUser: registeredUser ?? this.registeredUser,
    );
  }
}

class RegistrationZoneInfo {
  final Governorate? selectedGovernorate;
  final Zone? selectedZone;
  final String nearestLandmark;
  final double? latitude;
  final double? longitude;

  RegistrationZoneInfo({
    this.selectedGovernorate,
    this.selectedZone,
    this.nearestLandmark = '',
    this.latitude,
    this.longitude,
  });

  RegistrationZoneInfo copyWith({
    Governorate? selectedGovernorate,
    Zone? selectedZone,
    String? nearestLandmark,
    double? latitude,
    double? longitude,
  }) {
    return RegistrationZoneInfo(
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedZone: selectedZone ?? this.selectedZone,
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() => {
        'zoneId': selectedZone?.id,
        'nearestLandmark': nearestLandmark,
        'long': longitude,
        'lat': latitude,
      };

  bool get isValid =>
      selectedZone != null &&
      nearestLandmark.isNotEmpty &&
      latitude != null &&
      longitude != null;
}

@riverpod
class RegistrationNotifier extends _$RegistrationNotifier {
  final AuthService _authService = AuthService();
  final BaseClient _baseClient = BaseClient();
  final ZoneService _zoneService = ZoneService();

  @override
  RegistrationState build() {
    return const RegistrationState();
  }

  void updateUserInfo({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
  }) {
    state = state.copyWith(
      fullName: fullName,
      brandName: brandName,
      userName: userName,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
      error: null,
    );
  }

  void setBrandImage(XFile image) {
    state = state.copyWith(brandImage: image, error: null);
  }

  Future<bool> uploadBrandImage() async {
    if (state.brandImage == null) return false;

    state = state.copyWith(isUploadingImage: true, error: null);

    try {
      final result = await _baseClient.uploadFile(state.brandImage!.path);
      if (result.data != null && result.data!.isNotEmpty) {
        state = state.copyWith(
          uploadedImageUrl: result.data!.first,
          isUploadingImage: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'فشل في رفع الصورة',
          isUploadingImage: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'خطأ في رفع الصورة: ${e.toString()}',
        isUploadingImage: false,
      );
      return false;
    }
  }

  void addMarchentZone() {
    final newZones = List<RegistrationZoneInfo>.from(state.zones)
      ..add(RegistrationZoneInfo());
    state = state.copyWith(zones: newZones);
  }

  void updateZone(int index, RegistrationZoneInfo zoneInfo) {
    if (index >= state.zones.length) return;

    final newZones = List<RegistrationZoneInfo>.from(state.zones);
    newZones[index] = zoneInfo;
    state = state.copyWith(zones: newZones);
  }

  void removeZone(int index) {
    if (index >= state.zones.length || state.zones.length <= 1) return;

    final newZones = List<RegistrationZoneInfo>.from(state.zones)
      ..removeAt(index);
    state = state.copyWith(zones: newZones);
  }

  Future<void> loadAvailableZones() async {
    state = state.copyWith(isLoadingZones: true, error: null);

    try {
      final zones = await _zoneService.getAllZones();

      state = state.copyWith(
        availableZones: [],
        isLoadingZones: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'فشل في جلب المناطق: ${e.toString()}',
        isLoadingZones: false,
      );
    }
  }

  bool validateUserInfo() {
    final s = state;
    if (s.fullName?.isEmpty ?? true) {
      state = state.copyWith(error: 'اسم صاحب المتجر مطلوب');
      return false;
    }
    if (s.brandName?.isEmpty ?? true) {
      state = state.copyWith(error: 'اسم المتجر مطلوب');
      return false;
    }
    if (s.userName?.isEmpty ?? true) {
      state = state.copyWith(error: 'اسم المستخدم مطلوب');
      return false;
    }
    if (s.phoneNumber?.isEmpty ?? true) {
      state = state.copyWith(error: 'رقم الهاتف مطلوب');
      return false;
    }
    if (s.password?.isEmpty ?? true) {
      state = state.copyWith(error: 'كلمة المرور مطلوبة');
      return false;
    }
    if (s.password != s.confirmPassword) {
      state = state.copyWith(error: 'كلمة المرور غير متطابقة');
      return false;
    }
    if (s.brandImage == null) {
      state = state.copyWith(error: 'صورة المتجر مطلوبة');
      return false;
    }

    state = state.copyWith(error: null);
    return true;
  }

  bool validateZones() {
    if (state.zones.isEmpty) {
      state = state.copyWith(error: 'يجب إضافة منطقة واحدة على الأقل');
      return false;
    }

    for (int i = 0; i < state.zones.length; i++) {
      if (!state.zones[i].isValid) {
        state = state.copyWith(error: 'يجب إكمال معلومات المنطقة ${i + 1}');
        return false;
      }
    }

    state = state.copyWith(error: null);
    return true;
  }

  Future<bool> submitRegistration() async {
    if (!validateUserInfo() || !validateZones()) {
      return false;
    }

    if (state.uploadedImageUrl == null) {
      final uploaded = await uploadBrandImage();
      if (!uploaded) return false;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final zonesData = state.zones.map((z) => z.toJson()).toList();
      final firstZoneType = state.zones.first.selectedZone?.type ?? 1;

      print('🔍 البيانات المرسلة للباك اند:');
      print('📝 الاسم الكامل: ${state.fullName}');
      print('🏪 اسم المتجر: ${state.brandName}');
      print('👤 اسم المستخدم: ${state.userName}');
      print('📱 رقم الهاتف: ${state.phoneNumber}');
      print('🖼️ رابط الصورة: ${state.uploadedImageUrl}');
      print('🌍 عدد المناطق: ${zonesData.length}');
      print('📍 بيانات المناطق: $zonesData');
      print('🏷️ نوع المنطقة: $firstZoneType');

      final requestData = {
        'merchantId': null,
        'fullName': state.fullName!,
        'brandName': state.brandName!,
        'brandImg': state.uploadedImageUrl!,
        'userName': state.userName!,
        'phoneNumber': state.phoneNumber!,
        'img': state.uploadedImageUrl!,
        'zones': zonesData,
        'password': state.password!,
        'type': firstZoneType,
      };
      
      print('📤 JSON المرسل كاملاً: $requestData');

      final (user, error) = await _authService.register(
        fullName: state.fullName!,
        brandName: state.brandName!,
        userName: state.userName!,
        phoneNumber: state.phoneNumber!,
        password: state.password!,
        brandImg: state.uploadedImageUrl!,
        zones: zonesData,
        type: firstZoneType,
      );

      if (user != null) {
        print('✅ نجح التسجيل: ${user.fullName}');
        state = state.copyWith(
          isSubmitting: false,
          registeredUser: user,
        );
        return true;
      } else {
        print('❌ فشل التسجيل: $error');
        state = state.copyWith(
          error: error ?? 'فشل في التسجيل',
          isSubmitting: false,
        );
        return false;
      }
    } catch (e) {
      print('💥 خطأ استثنائي: $e');
      state = state.copyWith(
        error: 'خطأ في التسجيل: ${e.toString()}',
        isSubmitting: false,
      );
      return false;
    }
  }

  void reset() {
    state = const RegistrationState();
  }

  void addNewZone() {
    final newZones = List<RegistrationZoneInfo>.from(state.zones)
      ..add(RegistrationZoneInfo());
    state = state.copyWith(zones: newZones);
  }

  void updateZoneInfo(int index, RegistrationZoneInfo zoneInfo) {
    if (index >= state.zones.length) return;

    final newZones = List<RegistrationZoneInfo>.from(state.zones);
    newZones[index] = zoneInfo;
    state = state.copyWith(zones: newZones, error: null);
  }

  void deleteZone(int index) {
    if (index >= state.zones.length || state.zones.length <= 1) return;

    final newZones = List<RegistrationZoneInfo>.from(state.zones)
      ..removeAt(index);
    state = state.copyWith(zones: newZones);
  }
}




















//////////////////////
// lib/Features/auth/Services/auth_service.dart
import 'dart:async';
import 'package:Tosell/core/Model/auth/User.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/APIendpoint.dart';

class AuthService {
  final BaseClient<User> baseClient;

  AuthService()
      : baseClient = BaseClient<User>(fromJson: (json) => User.fromJson(json));
  Future<(User? data, String? error)> login(
      {String? phoneNumber, required String password}) async {
    try {
      var result =
          await baseClient.create(endpoint: AuthEndpoints.login, data: {
        'phoneNumber': phoneNumber,
        'password': password,
      });

      if (result.singleData == null) return (null, result.message);
      return (result.getSingle, null);
    } catch (e) {
      return (null, e.toString());
    }
  }

  /// ✅ دالة تسجيل التاجر مع التعامل الصحيح مع الاستجابة
  Future<(User? data, String? error)> register({
    required String fullName,
    required String brandName,
    required String userName,
    required String phoneNumber,
    required String password,
    required String brandImg, // ✅ يجب أن يكون URL من رفع الصورة
    required List<Map<String, dynamic>> zones,
    required int type,
  }) async {
    try {
      final isValidUrl =
          brandImg.startsWith('https://') || brandImg.startsWith('http://');

      if (!isValidUrl) {
        return (null, 'صورة المتجر لم يتم معالجتها بشكل صحيح');
      }
      if (zones.isEmpty) {
        return (null, 'يجب اختيار منطقة واحدة على الأقل');
      }

      for (int i = 0; i < zones.length; i++) {
        final zone = zones[i];
        print('   📍 المنطقة ${i + 1}:');
        print(
            '      - zoneId: ${zone['zoneId']} ${zone['zoneId'] != null && zone['zoneId'] > 0 ? '✅' : '❌'}');
        print(
            '      - nearestLandmark: "${zone['nearestLandmark']}" ${zone['nearestLandmark']?.toString().isNotEmpty == true ? '✅' : '❌'}');
        print('      - lat: ${zone['lat']} ${zone['lat'] != null ? '✅' : '❌'}');
        print(
            '      - long: ${zone['long']} ${zone['long'] != null ? '✅' : '❌'}');

        // ✅ التحقق من صحة بيانات المنطقة
        if (zone['zoneId'] == null || zone['zoneId'] <= 0) {
          print('❌ خطأ: zoneId غير صحيح في المنطقة ${i + 1}');
          return (null, 'معرف المنطقة غير صحيح');
        }

        if (zone['nearestLandmark'] == null ||
            zone['nearestLandmark'].toString().trim().isEmpty) {
          print('❌ خطأ: nearestLandmark فارغ في المنطقة ${i + 1}');
          return (null, 'أقرب نقطة دالة مطلوبة لكل منطقة');
        }

        if (zone['lat'] == null || zone['long'] == null) {
          print('❌ خطأ: إحداثيات ناقصة في المنطقة ${i + 1}');
          return (null, 'يجب تحديد الموقع على الخريطة لكل منطقة');
        }
      }

      // ✅ تدقيق النوع
      print('🏷️ التحقق من النوع:');
      print('   - type: $type');
      if (type != 1 && type != 2) {
        print('⚠️ تحذير: type = $type (مقبول لكن غير معتاد، المتوقع: 1 أو 2)');
      } else {
        print('   - المعنى: ${type == 1 ? 'مركز' : 'أطراف'} ✅');
      }

      // ✅ تحضير البيانات بالشكل المطلوب تماماً
      final requestData = {
        'merchantId': null, // ✅ null كما طلب
        'fullName': fullName,
        'brandName': brandName,
        'brandImg': brandImg, // ✅ URL من رفع الصورة
        'userName': userName,
        'phoneNumber': phoneNumber,
        'img': brandImg, // ✅ نفس brandImg كما مطلوب
        'zones': zones, // ✅ قائمة بالشكل المطلوب
        'password': password,
        'type': type, // ✅ نوع المنطقة
      };

      print('📤 البيانات النهائية المرسلة:');
      print('📋 JSON كامل:');
      print(requestData);

      // ✅ طباعة حجم البيانات للتأكد
      print('📏 إحصائيات:');
      print('   - حجم zones: ${zones.length} منطقة');
      print('   - طول brandImg: ${brandImg.length} حرف');
      print('   - طول fullName: ${fullName.length} حرف');
      print('   - طول brandName: ${brandName.length} حرف');

      // ✅ إرسال الطلب
      var result = await baseClient.create(
        endpoint: AuthEndpoints.register,
        data: requestData,
      );

      if (result.code == 200 && result.message == "Operation successful") {
        // ✅ إرجاع حالة خاصة للتمييز
        return (null, "REGISTRATION_SUCCESS_PENDING_APPROVAL");
      }

      User? user;
      if (result.singleData != null) {
        user = result.singleData;

        return (user, null);
      } else if (result.data != null && result.data!.isNotEmpty) {
        user = result.data!.first;

        return (user, null);
      }

      return (null, result.message ?? 'استجابة غير متوقعة من الخادم');
    } catch (e) {
      return (null, 'خطأ في التسجيل: ${e.toString()}');
    }
  }
}
