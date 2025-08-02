import 'package:dio/dio.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:benevolent_crm_app/app/utils/token_storage.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? Dio(),
      _tokenStorage = tokenStorage ?? TokenStorage() {
    _dio.options.baseUrl = ApiEndPoints.BASEURL;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, data: data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> setToken(String token) async {
    await _tokenStorage.saveToken(token);
  }

  Future<void> clearToken() async {
    await _tokenStorage.clearToken();
  }
}
