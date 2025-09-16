// lib/core/api/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';


import '../../config/routes/app_router.dart';
import '../../utils/helpers/SharedPreferencesHelper.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // نفس الكود الموجود عندك - إضافة Token
    final token = (await SharedPreferencesHelper.getUser())?.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      await SharedPreferencesHelper.removeUser();
      appRouter.go('/login');
    }
    handler.next(error);
  }
}