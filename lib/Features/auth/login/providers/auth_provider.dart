// lib/Features/auth/login/providers/auth_provider.dart
import 'package:Tosell/Features/auth/Services/auth_service.dart';
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class authNotifier extends _$authNotifier {
  final AuthService _service = AuthService();

  String _buildFullImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // الرابط كامل بالفعل
      return imagePath;
    } else if (imagePath.startsWith('/')) {
      return '$imageUrl${imagePath.substring(1)}';
    } else {
      return '$imageUrl$imagePath';
    }
  }

  /// ✅ دالة التسجيل محسنة للأداء
  Future<(User? data, String? error)> register({
    required String fullName,
    required String brandName,
    required String userName,
    required String phoneNumber,
    required String password,
    required String brandImg,
    required List<Zone> zones,
    String? nearestLandmark,
    double? latitude,
    double? longitude,
  }) async {
    try {
      state = const AsyncValue.loading();

      // ✅ التحقق من صحة البيانات الأساسية (مبسط)
      final validationError = _validateRegistrationData(fullName, brandName,
          userName, phoneNumber, password, brandImg, zones);
      if (validationError != null) {
        state = const AsyncValue.data(null);
        if (kDebugMode) print('❌ AuthProvider: $validationError');
        return (null, validationError);
      }

      // ✅ معالجة البيانات في isolate منفصل للعمليات الثقيلة
      final processedData = await compute(_processRegistrationData, {
        'fullName': fullName.trim(),
        'brandName': brandName.trim(),
        'userName': userName.trim(),
        'phoneNumber': phoneNumber.trim(),
        'brandImg': brandImg,
        'zones': zones
            .map((z) => {
                  'id': z.id,
                  'name': z.name,
                  'type': z.type,
                  'governorate': z.governorate?.name,
                })
            .toList(),
        'nearestLandmark': nearestLandmark,
        'latitude': latitude,
        'longitude': longitude,
      });

      if (kDebugMode) print('🚀 إرسال البيانات إلى AuthService...');

      final (user, error) = await _service.register(
        fullName: processedData['fullName'],
        brandName: processedData['brandName'],
        userName: processedData['userName'],
        phoneNumber: processedData['phoneNumber'],
        password: password,
        brandImg: processedData['fullImageUrl'],
        zones: processedData['zonesData'],
        type: processedData['firstZoneType'],
      );

      if (user == null) {
        state = const AsyncValue.data(null);
        if (kDebugMode) print('❌ AuthProvider: فشل التسجيل - $error');
        return (null, error);
      }

      // ✅ حفظ بيانات المستخدم محلياً
      if (kDebugMode) print('✅ AuthProvider: نجح التسجيل - ${user.fullName}');
      await SharedPreferencesHelper.saveUser(user);
      state = AsyncValue.data(user);

      return (user, null);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('💥 AuthProvider Exception: $e');
        print('📍 Stack trace: $stackTrace');
      }
      state = AsyncValue.error(e, stackTrace);
      return (null, 'خطأ غير متوقع: ${e.toString()}');
    }
  }

  /// ✅ التحقق من صحة البيانات (مبسط)
  String? _validateRegistrationData(
      String fullName,
      String brandName,
      String userName,
      String phoneNumber,
      String password,
      String brandImg,
      List<Zone> zones) {
    if (fullName.trim().isEmpty) return 'اسم صاحب المتجر مطلوب';
    if (brandName.trim().isEmpty) return 'اسم المتجر مطلوب';
    if (userName.trim().isEmpty) return 'اسم المستخدم مطلوب';
    if (phoneNumber.trim().isEmpty) return 'رقم الهاتف مطلوب';
    if (password.isEmpty) return 'كلمة المرور مطلوبة';
    if (brandImg.trim().isEmpty) return 'صورة المتجر مطلوبة';
    if (zones.isEmpty) return 'يجب اختيار منطقة واحدة على الأقل';
    return null;
  }

  /// ✅ معالجة بيانات التسجيل في isolate منفصل
  static Map<String, dynamic> _processRegistrationData(
      Map<String, dynamic> data) {
    final fullImageUrl = _buildFullImageUrlStatic(data['brandImg']);

    final List<Map<String, dynamic>> zonesData = [];
    final zones = data['zones'] as List;

    for (int i = 0; i < zones.length; i++) {
      final zone = zones[i];
      final zoneData = {
        'zoneId': zone['id'],
        'nearestLandmark':
            data['nearestLandmark']?.toString().trim().isNotEmpty == true
                ? data['nearestLandmark'].toString().trim()
                : 'نقطة مرجعية ${i + 1}',
        'long': data['longitude'] ?? 44.3661,
        'lat': data['latitude'] ?? 33.3152,
      };
      zonesData.add(zoneData);
    }

    final firstZoneType = zones.isNotEmpty ? (zones.first['type'] ?? 1) : 1;

    return {
      'fullName': data['fullName'],
      'brandName': data['brandName'],
      'userName': data['userName'],
      'phoneNumber': data['phoneNumber'],
      'fullImageUrl': fullImageUrl,
      'zonesData': zonesData,
      'firstZoneType': firstZoneType,
    };
  }

  /// ✅ نسخة static من دالة بناء URL الصورة للاستخدام في isolate
  static String _buildFullImageUrlStatic(String imagePath) {
    const imageUrl = 'https://api.example.com/images/';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    } else if (imagePath.startsWith('/')) {
      return '$imageUrl${imagePath.substring(1)}';
    } else {
      return '$imageUrl$imagePath';
    }
  }

  /// ✅ دالة تسجيل الدخول محسنة للأداء
  Future<(User? data, String? error)> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();

      // ✅ التحقق من صحة البيانات (مبسط)
      if (phoneNumber.trim().isEmpty) {
        state = const AsyncValue.data(null);
        if (kDebugMode) print('❌ AuthProvider: رقم الهاتف فارغ');
        return (null, 'رقم الهاتف مطلوب');
      }

      if (password.isEmpty) {
        state = const AsyncValue.data(null);
        if (kDebugMode) print('❌ AuthProvider: كلمة المرور فارغة');
        return (null, 'كلمة المرور مطلوبة');
      }

      if (kDebugMode) print('🔐 AuthProvider: بدء تسجيل الدخول...');

      // ✅ استدعاء AuthService
      final (user, error) = await _service.login(
        phoneNumber: phoneNumber.trim(),
        password: password,
      );

      if (user == null) {
        state = const AsyncValue.data(null);
        if (kDebugMode) print('❌ AuthProvider: فشل تسجيل الدخول - $error');
        return (null, error);
      }

      // ✅ التحقق من حالة التفعيل
      if (user.isActive != true) {
        state = const AsyncValue.data(null);
        if (kDebugMode)
          print('⚠️ AuthProvider: الحساب غير مفعل - ${user.fullName}');
        return (null, 'حسابك غير مفعل. يرجى التواصل مع الإدارة');
      }

      // ✅ حفظ بيانات المستخدم محلياً
      if (kDebugMode)
        print('✅ AuthProvider: نجح تسجيل الدخول - ${user.fullName}');
      await SharedPreferencesHelper.saveUser(user);
      state = AsyncValue.data(user);

      return (user, null);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('💥 AuthProvider Exception: $e');
        print('📍 Stack trace: $stackTrace');
      }
      state = AsyncValue.error(e, stackTrace);
      return (null, 'خطأ غير متوقع: ${e.toString()}');
    }
  }

  @override
  FutureOr<void> build() async {
    return;
  }
}
