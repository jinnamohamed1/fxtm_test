import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';

abstract class ForexSymbolsRemoteDataSource {
  Future<List<ForexSymbolModel>> fetchForexSymbols({required String exchange});
}

class ForexSymbolsRemoteDataSourceImpl implements ForexSymbolsRemoteDataSource {
  final ApiClient _apiClient;
  ForexSymbolsRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<ForexSymbolModel>> fetchForexSymbols(
      {required String exchange}) async {
    if (exchange.isEmpty) {
      throw Exception('Exchange cannot be empty');
    }
    final response = await _apiClient.get<List<dynamic>>(
      path: "/forex/symbol",
      queryParameters: {
        "exchange": exchange,
      },
    );
    final responseData = response.data;
    if (responseData != null) {
      return responseData
          .map((json) => ForexSymbolModel.fromJson(json))
          .toList();
    } else {
      throw Exception(response.error);
    }
  }
}
