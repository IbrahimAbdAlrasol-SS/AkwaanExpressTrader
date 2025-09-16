import 'dart:async';

import 'dart:developer' as developer;

import 'package:Tosell/core/api/client/ApiResponse.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/core/api/interceptors/auth_interceptor.dart';
import 'package:Tosell/core/api/interceptors/logging_interceptor.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:dio/dio.dart';

const imageUrl = APIEndpoints.imageUrl;
const baseUrl = APIEndpoints.baseUrl;

class BaseClient<T> {
  final Dio _dio = Dio();
  final int _timeoutSeconds = 30;

  final Function(Map<String, dynamic>)? fromJson;
  BaseClient({this.fromJson}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: _timeoutSeconds),
      receiveTimeout: Duration(seconds: _timeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // استخدم interceptors المنفصلة بدلاً من InterceptorsWrapper
    _dio.interceptors.addAll([
      AuthInterceptor(), // للمصادقة
      LoggingInterceptor(), // لتسجيل الطلبات (مفيد للتطوير)
    ]);
  }

  Future<ApiResponse<T>> create({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    print('🌐 BaseClient.create() - بدء HTTP POST Request');
    print('  - URL: $baseUrl$endpoint');
    print('  - Data: $data');

    try {
      print('📡 إرسال POST request...');
      final response = await _dio.post(endpoint, data: data);

      print('📥 استجابة HTTP:');
      print('  - Status Code: ${response.statusCode}');
      print('  - Response Data: ${response.data}');

      final result = _handleResponse(response);
      print('✅ تم معالجة الاستجابة بنجاح');
      return result;
    } on DioException catch (e) {
      print('💥 DioException في BaseClient.create():');
      print('  - Type: ${e.type}');
      print('  - Message: ${e.message}');
      print('  - Status Code: ${e.response?.statusCode}');
      print('  - Response Data: ${e.response?.data}');
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> getById({
    required String endpoint,
    required String id,
  }) async {
    try {
      final response = await _dio.get('$endpoint/$id');
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> get({required String endpoint}) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  FutureOr<T> get_noResponse({required String endpoint}) async {
    try {
      final response = await _dio.get(endpoint);
      return fromJson!(response.data);
    } on DioException catch (e) {
      // في حالة حدوث خطأ، نرمي الخطأ بدلاً من إرجاع البيانات الخام
      throw e;
    }
  }

  Future<ApiResponse<T>> getAll(
      {required String endpoint,
      int page = 1,
      Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          ...?queryParams,
          'pageNumber': page,
        },
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> update({
    required String endpoint,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<String>> uploadFile(String selectedImagePath) async {
    try {
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          selectedImagePath,
          filename: selectedImagePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        FileEndpoints.multi,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final urls = (response.data['data'] as List)
            .map<String>((file) => file['url'].toString())
            .toList();
        return ApiResponse<String>(data: urls);
      }
      return ApiResponse<String>(
        message: response.data['message'] ?? 'Upload failed',
        data: [],
        errorType: ApiErrorType.serverError,
      );
    } on DioException catch (e) {
      return ApiResponse<String>(
        message: e.response?.data['message'] ?? 'Upload error',
        data: [],
        errorType: ApiErrorType.serverError,
      );
    }
  }

  ApiResponse<T> _handleResponse(Response response) {
    developer.log('🔄 BaseClient._handleResponse() - معالجة الاستجابة',
        name: 'BaseClient');
    developer.log('  - Status Code: ${response.statusCode}',
        name: 'BaseClient');
    
    // طباعة البيانات الخام من الخادم
    print('📄 BaseClient - البيانات الخام من الخادم:');
    print('  - Raw Response: ${response.data}');
    print('  - Response Type: ${response.data.runtimeType}');
    
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> responseMap = response.data;
      print('📋 BaseClient - تفاصيل الاستجابة:');
      print('  - Contains code: ${responseMap.containsKey("code")}');
      print('  - Contains message: ${responseMap.containsKey("message")}');
      print('  - Contains data: ${responseMap.containsKey("data")}');
      print('  - Contains errors: ${responseMap.containsKey("errors")}');
      if (responseMap.containsKey('code')) {
        print('  - Code value: ${responseMap["code"]}');
      }
      if (responseMap.containsKey('message')) {
        print('  - Message value: ${responseMap["message"]}');
      }
    }

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      developer.log('✅ استجابة ناجحة - تحويل البيانات', name: 'BaseClient');
      final result = ApiResponse.fromJsonAuto(response.data, fromJson!);
      developer.log('  - Parsed Code: ${result.code}', name: 'BaseClient');
      developer.log('  - Parsed Message: ${result.message}', name: 'BaseClient');
      developer.log('  - Has Single Data: ${result.singleData != null}', name: 'BaseClient');
      developer.log('  - Has List Data: ${result.data?.isNotEmpty ?? false}', name: 'BaseClient');
      return ApiResponse<T>(
        code: result.code,
        message: result.message,
        data: result.data?.cast<T>() ?? [],
        singleData: result.singleData as T?,
        pagination: result.pagination,
        errors: result.errors,
        errorType: result.errorType,
      );
    }

    developer.log('❌ استجابة فاشلة', name: 'BaseClient');
    developer.log('  - Error Message: ${response.data['message']}',
        name: 'BaseClient');
    developer.log('  - Errors: ${response.data['errors']}', name: 'BaseClient');

    return ApiResponse<T>(
      message: response.data['message'] ?? 'Unknown error',
      data: [],
      errors: response.data['errors'],
      errorType: ApiErrorType.serverError,
    );
  }

  ApiResponse<T> _handleDioError(DioException e) {
    print('💥 BaseClient._handleDioError() - معالجة خطأ Dio');
    print('  - Exception Type: ${e.type}');
    print('  - Exception Message: ${e.message}');
    print('  - Response Data: ${e.response?.data}');
    print('  - Status Code: ${e.response?.statusCode}');

    ApiErrorType errorType;
    String message = '';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorType = ApiErrorType.timeout;
        message = 'Request timed out';
        developer.log('⏰ خطأ انتهاء المهلة الزمنية', name: 'BaseClient');
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        developer.log('📛 استجابة سيئة - Status Code: $statusCode',
            name: 'BaseClient');
        developer.log('  - Response Data: ${e.response?.data}',
            name: 'BaseClient');
        if (statusCode == 401) {
          errorType = ApiErrorType.unauthorized;
          message = 'Unauthorized';
          developer.log('🔒 خطأ عدم تفويض (401)', name: 'BaseClient');
        } else {
          errorType = ApiErrorType.serverError;
          message = e.response?.data['message'] ?? 'Server error';
          developer.log('🔥 خطأ خادم: $message', name: 'BaseClient');
        }
        break;
      case DioExceptionType.cancel:
        errorType = ApiErrorType.unknown;
        message = 'Request cancelled';
        developer.log('🚫 تم إلغاء الطلب', name: 'BaseClient');
        break;
      case DioExceptionType.unknown:
        if (e.message != null && e.message!.contains('SocketException')) {
          errorType = ApiErrorType.noInternet;
          message = 'No internet connection';
          developer.log('📡 لا يوجد اتصال بالإنترنت', name: 'BaseClient');
        } else {
          errorType = ApiErrorType.unknown;
          message = 'Unknown error: ${e.message}';
        }
        break;
      default:
        errorType = ApiErrorType.unknown;
        message = 'Unexpected error';
    }

    return ApiResponse<T>(
      message: message,
      data: [],
      errors: e.response?.data['errors'],
      errorType: errorType,
    );
  }
}
