// lib/Features/auth/Services/auth_service.dart
import 'dart:async';

import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/client/ApiResponse.dart';
import 'package:Tosell/core/model_core/User.dart';

class AuthService {
  final BaseClient<User> baseClient;

  AuthService()
      : baseClient = BaseClient<User>(fromJson: (json) => User.fromJson(json));

  /// دالة تسجيل الدخول - تعمل بشكل جيد (لا تغيير)
  Future<(User? data, String? error)> login(
      {String? phoneNumber, required String password}) async {
    try {
      var result = await baseClient.create(endpoint: '/auth/login', data: {
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
      print('🚀 AuthService: بدء تسجيل التاجر...');
      print('🔧 BaseClient instance: ${baseClient.toString()}');
      
      // ✅ تدقيق البيانات الأساسية
      print('📝 التحقق من البيانات الأساسية:');
      print('   - fullName: "$fullName" ${fullName.isNotEmpty ? '✅' : '❌ فارغ'}');
      print('   - brandName: "$brandName" ${brandName.isNotEmpty ? '✅' : '❌ فارغ'}');
      print('   - userName: "$userName" ${userName.isNotEmpty ? '✅' : '❌ فارغ'}');
      print('   - phoneNumber: "$phoneNumber" ${phoneNumber.isNotEmpty ? '✅' : '❌ فارغ'}');
      print('   - password: "${password.isNotEmpty ? '***' : 'فارغ'}" ${password.isNotEmpty ? '✅' : '❌ فارغ'}');
      
      // ✅ تدقيق رابط الصورة
      print('🖼️ التحقق من الصورة:');
      print('   - brandImg: "$brandImg"');
      print('   - الطول: ${brandImg.length} حرف');
      
      // ✅ التحقق من أنه URL كامل
      final isValidUrl = brandImg.startsWith('https://') || brandImg.startsWith('http://');
      
      if (!isValidUrl) {
        print('❌ خطأ: brandImg ليس URL كامل');
        print('   الرابط المستلم: "$brandImg"');
        print('   المتوقع: رابط يبدأ بـ http:// أو https://');
        return (null, 'صورة المتجر لم يتم معالجتها بشكل صحيح');
      }
      
      print('   ✅ رابط صحيح وكامل');
      print('   🌐 النطاق: ${brandImg.contains('toseel-api.future-wave.co') ? 'موقع توصيل' : 'خارجي'}');

      // ✅ تدقيق المناطق
      print('🌍 التحقق من المناطق:');
      print('   - عدد المناطق: ${zones.length}');
      
      if (zones.isEmpty) {
        print('❌ خطأ: لا توجد مناطق');
        return (null, 'يجب اختيار منطقة واحدة على الأقل');
      }

      for (int i = 0; i < zones.length; i++) {
        final zone = zones[i];
        print('   📍 المنطقة ${i + 1}:');
        print('      - zoneId: ${zone['zoneId']} ${zone['zoneId'] != null && zone['zoneId'] > 0 ? '✅' : '❌'}');
        print('      - nearestLandmark: "${zone['nearestLandmark']}" ${zone['nearestLandmark']?.toString().isNotEmpty == true ? '✅' : '❌'}');
        print('      - lat: ${zone['lat']} ${zone['lat'] != null ? '✅' : '❌'}');
        print('      - long: ${zone['long']} ${zone['long'] != null ? '✅' : '❌'}');
        
        // ✅ التحقق من صحة بيانات المنطقة
        if (zone['zoneId'] == null || zone['zoneId'] <= 0) {
          print('❌ خطأ: zoneId غير صحيح في المنطقة ${i + 1}');
          return (null, 'معرف المنطقة غير صحيح');
        }
        
        if (zone['nearestLandmark'] == null || zone['nearestLandmark'].toString().trim().isEmpty) {
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
      print('📡 AuthService: استدعاء baseClient.create...');
      print('📡 Endpoint: /auth/merchant-register');
      print('📡 Data keys: ${requestData.keys.toList()}');
      
      var result = await baseClient.create(
        endpoint: '/auth/merchant-register',
        data: requestData,
      );

      print('📥 استجابة الخادم:');
      print('   - Code: ${result.code}');
      print('   - Message: ${result.message}');
      print('   - ErrorType: ${result.errorType}');
      print('   - Errors: ${result.errors}');
      print('   - Has SingleData: ${result.singleData != null}');
      print('   - Has ListData: ${result.data?.isNotEmpty ?? false}');

      // ✅ معالجة الأخطاء بشكل أفضل
      if (result.errorType != null) {
        String errorMessage;
        switch (result.errorType) {
          case ApiErrorType.noInternet:
            errorMessage = 'لا يوجد اتصال بالإنترنت. تحقق من الاتصال وحاول مرة أخرى';
            break;
          case ApiErrorType.timeout:
            errorMessage = 'انتهت مهلة الاتصال. حاول مرة أخرى';
            break;
          case ApiErrorType.unauthorized:
            errorMessage = 'خطأ في التفويض. تحقق من البيانات';
            break;
          case ApiErrorType.serverError:
            // ✅ عرض رسالة الخطأ من الخادم إذا كانت متوفرة
            if (result.errors != null && result.errors is Map) {
              final errors = result.errors as Map;
              final errorMessages = <String>[];
              errors.forEach((key, value) {
                if (value is List) {
                  errorMessages.addAll(value.map((e) => e.toString()));
                } else {
                  errorMessages.add(value.toString());
                }
              });
              errorMessage = errorMessages.isNotEmpty 
                  ? errorMessages.join('\n') 
                  : result.message ?? 'خطأ في الخادم';
            } else {
              errorMessage = result.message ?? 'خطأ في الخادم';
            }
            break;
          default:
            errorMessage = result.message ?? 'خطأ غير معروف';
        }
        print('❌ AuthProvider: فشل التسجيل - $errorMessage');
        return (null, errorMessage);
      }
      
      if (result.code == 200 && result.message == "Operation successful") {
        print('✅ AuthProvider: تم التسجيل بنجاح - في انتظار الموافقة');
        // ✅ إرجاع حالة خاصة للتمييز
        return (null, "REGISTRATION_SUCCESS_PENDING_APPROVAL");
      }
      
      User? user;
      if (result.singleData != null) {
        user = result.singleData;
        print('✅ AuthProvider: تم التسجيل وتفعيل الحساب مباشرة');
        return (user, null);
        
      } else if (result.data != null && result.data!.isNotEmpty) {
        user = result.data!.first;
        print('✅ AuthProvider: تم التسجيل وتفعيل الحساب مباشرة');
        return (user, null);
      }

      print('❌ AuthProvider: استجابة غير متوقعة من الخادم');
      return (null, result.message ?? 'استجابة غير متوقعة من الخادم');
      
    } catch (e) {
      print('💥 AuthProvider: خطأ استثنائي في التسجيل - ${e.toString()}');
      return (null, 'خطأ في التسجيل: ${e.toString()}');
    }
  }
}