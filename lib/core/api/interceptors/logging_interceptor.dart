// lib/core/api/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('🚀 طلب: ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log('✅ استجابة: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    developer.log('❌ خطأ: ${error.response?.statusCode} ${error.message}');
    handler.next(error);
  }
}