import 'package:dio/dio.dart';
import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/core/api_client/api_response.dart';

class ApiClientImpl implements ApiClient {
  final Dio _client;
  final String _baseUrl;

  ApiClientImpl({
    required Dio? client,
    required String baseUrl,
    required String apiKeyToken,
  })  : _client = client ?? Dio(),
        _baseUrl = baseUrl {
    _client.options.queryParameters = {
      "token": apiKeyToken, // Automatically appends to every request
    };
  }

  @override
  Future<ApiResponse<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _client.get(
        '$_baseUrl$path',
        queryParameters: queryParameters,
      );
      return ApiResponse(data: response.data);
    } on DioException catch (e) {
      return ApiResponse(error: e.message);
    }
  }

  @override
  Future<ApiResponse<T>> delete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<T>> patch<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<T>> post<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<T>> put<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
