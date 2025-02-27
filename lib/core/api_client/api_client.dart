import 'package:fxtm_test_app/core/api_client/api_response.dart';

abstract class ApiClient {
  Future<ApiResponse<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResponse<T>> post<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });

  Future<ApiResponse<T>> put<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });

  Future<ApiResponse<T>> delete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResponse<T>> patch<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });
}
