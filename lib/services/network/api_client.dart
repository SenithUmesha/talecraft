import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:talecraft/utils/app_widgets.dart';

import 'app_exception.dart';

class ApiClient {
  static ApiClient _apiClient = ApiClient._internal();
  final Dio _dio = Dio();

  factory ApiClient() {
    return _apiClient;
  }

  Dio get client => _dio;

  ApiClient._internal() {
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) =>
                requestInterceptor(options, handler),
        onResponse: (Response response, ResponseInterceptorHandler handler) =>
            responseInterceptor(response, handler),
        onError: (DioException dioException, ErrorInterceptorHandler handler) =>
            errorInterceptorHandler(dioException, handler)));
  }
}

dynamic requestInterceptor(
    RequestOptions options, RequestInterceptorHandler handler) async {
  log("Request interceptor\nData => \n ${options.data}");
  return handler.next(options);
}

dynamic responseInterceptor(
    Response response, ResponseInterceptorHandler handler) async {
  if (response.statusCode != null) {
    if (response.statusCode! >= 400) {
      throw AppException(response.statusCode!, response.data);
    } else {
      log("Response interceptor\nData => \n ${response.data}");
      return handler.next(response);
    }
  }
}

dynamic errorInterceptorHandler(
    DioException dioException, ErrorInterceptorHandler handler) {
  AppWidgets.showToast("Unable to access the server");
  log("Error interceptor\nCode => \n ${dioException.response?.statusCode}");
}
