class ApiResponse<T> {
  int? code;
  String? message;
  List<T>? data;
  T? singleData;
  Pagination? pagination;
  dynamic errors;
  final ApiErrorType? errorType;

  ApiResponse({
    this.code,
    this.message,
    this.data,
    this.singleData,
    this.pagination,
    this.errors,
    this.errorType,
  });

  /// Automatically determines whether `data` is a list or a single object.
  factory ApiResponse.fromJsonAuto(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    dynamic rawData = json['data'];

    List<T>? dataList;
    T? singleItem;
    
    // معالجة البيانات كقائمة
    if (rawData is List) {
      try {
        dataList = [];
        for (var item in rawData) {
          if (item is Map<String, dynamic>) {
            dataList.add(fromJsonT(item));
          }
        }
      } catch (e) {
        print('خطأ في معالجة البيانات كقائمة: $e');
      }
    }
    
    // معالجة البيانات كعنصر واحد
    if (rawData is Map<String, dynamic>) {
      try {
        singleItem = fromJsonT(rawData);
      } catch (e) {
        print('خطأ في معالجة البيانات كعنصر واحد: $e');
      }
    }

    var result = ApiResponse<T>(
      code: json['code'],
      message: json['message'],
      data: dataList,
      singleData: singleItem,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      errors: json['errors'],
    );

    return result;
  }

  /// Helper method to check if the response contains a list.
  bool get hasList => data != null;

  /// Helper method to check if the response contains a single object.
  bool get hasSingle => singleData != null;

  /// Returns `data` as a list or an empty list if it's null.
  List<T> get getList => data ?? [];

  /// Returns `singleData` or throws an error if it's not available.
  T? get getSingle => singleData;
}

class Pagination {
  int? totalItems;
  int? pageSize;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.pageSize,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['totalItems'],
      pageSize: json['pageSize'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

enum ApiErrorType {
  noInternet,
  timeout,
  unauthorized,
  serverError,
  unknown,
}